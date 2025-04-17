import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:secondly/service/attendance_service.dart';
import 'package:secondly/service/auth_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  DateTime? clockInTime;
  DateTime? clockOutTime;
  String totalWorkingTime = "--:--:--";
  bool isClockedIn = false;
  bool isLoading = false;
  bool isDataLoading = false;
  
  // Location related variables
  Position? currentPosition;
  String? currentAddress;
  String? googleMapsUrl;
  String? checkInLocation;
  String? checkOutLocation;

  Timer? _timer;
  int _elapsedSeconds = 0;  // Track elapsed seconds


  static const int maxRetries = 3;
  static const int locationTimeout = 10; // seconds

  List<Map<String, dynamic>> dailyRecords = [];
  bool isDailyDataLoading = false;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void initState() {
    super.initState();
    _fetchAttendanceData();
    _fetchDailyAttendance(); 
  }

  

    // Function to get location permission and current position
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorSnackBar('Location services are disabled. Please enable the services');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorSnackBar('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorSnackBar('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  // Enhanced getCurrentPosition with retries
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    for (int i = 0; i < maxRetries; i++) {
      try {
        Position? position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: locationTimeout),
        ).timeout(
          Duration(seconds: locationTimeout),
          onTimeout: () {
            throw TimeoutException('Location request timed out');
          },
        );

        setState(() {
          currentPosition = position;
          googleMapsUrl = 'https://www.google.com/maps/@${position.latitude},${position.longitude},18z';
        });
        
        await _getAddressFromLatLng(position);
        return; // Success - exit the retry loop
        
      } catch (e) {
        debugPrint('Location attempt ${i + 1} failed: $e');
        
        if (e is TimeoutException) {
          _showErrorSnackBar('Location request timed out. Retrying...');
        } else if (e.toString().contains('LocationServiceDisabledException')) {
          _showErrorSnackBar('Location services are disabled');
          return;
        } else if (e.toString().contains('PermissionDeniedException')) {
          _showErrorSnackBar('Location permission denied');
          return;
        }

        // If this was the last retry
        if (i == maxRetries - 1) {
          _showErrorDialog(
            'Location Error',
            'Unable to get your location after several attempts. Please ensure you have:\n\n'
            '• Good GPS signal\n'
            '• Internet connectivity\n'
            '• Location services enabled\n\n'
            'Would you like to try again?'
          );
          return;
        }
        
        // Wait before retrying
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  // Address lookup with retrie
  Future<void> _getAddressFromLatLng(Position position) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(
          Duration(seconds: locationTimeout),
          onTimeout: () {
            throw TimeoutException('Address lookup timed out');
          },
        );

        if (placemarks.isEmpty) {
          throw Exception('No address found');
        }

        Placemark place = placemarks[0];
        setState(() {
          currentAddress = 
            '${place.street ?? ''}, ${place.subLocality ?? ''}, '
            '${place.subAdministrativeArea ?? ''}, ${place.postalCode ?? ''}, '
            '${place.country ?? ''}'
                .replaceAll(RegExp(r', ,'), ',')  // Remove empty components
                .replaceAll(RegExp(r',+'), ',')   // Remove multiple commas
                .replaceAll(RegExp(r'^\s*,\s*|\s*,\s*$'), '')  // Remove leading/trailing commas
                .trim();
        });
        return; // Success - exit the retry loop

      } catch (e) {
        debugPrint('Address lookup attempt ${i + 1} failed: $e');
        
        // If this was the last retry
        if (i == maxRetries - 1) {
          setState(() {
            currentAddress = 'Location found but address lookup failed';
          });
          _showErrorSnackBar('Could not get street address');
          return;
        }
        
        // Wait before retrying
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  Future<void> _fetchAttendanceData() async {
      setState(() {
        isDataLoading = true;
      });

      try {
        final userData = await AuthService.getCurrentUser();
        if (userData == null) {
          debugPrint('No user data available');
          return;
        }

        final today = DateTime.now();
        final formattedDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

        final attendanceData = await AttendanceService.getAttendanceData(
          userData.employeeId,
          formattedDate,
        );

        setState(() {
          // First, reset all states
          clockInTime = null;
          clockOutTime = null;
          isClockedIn = false;
          totalWorkingTime = "--:--:--";
          checkInLocation = null;
          checkOutLocation = null;

          if (attendanceData != null) {
            // Handle check-in and check-out times
            if (attendanceData['check_in'] != null) {
              clockInTime = DateTime.parse(attendanceData['check_in']);
              
              if (attendanceData['check_out'] != null) {
                clockOutTime = DateTime.parse(attendanceData['check_out']);
                isClockedIn = false; // User has completed their shift
              } else {
                isClockedIn = true; // User is currently clocked in
              }

              // Set total working time from the API data
              if (attendanceData['total_working_hours'] != null) {
                double totalHours = attendanceData['total_working_hours'].toDouble();
                int hours = totalHours.floor();
                int minutes = ((totalHours - hours) * 60).floor();
                int seconds = (((totalHours - hours) * 60 - minutes) * 60).round();
                
                totalWorkingTime = "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
              }
            }

            // Update location information
            checkInLocation = attendanceData['check_in_location'];
            checkOutLocation = attendanceData['check_out_location'];
          }
        });
      } catch (e) {
        debugPrint('Error fetching attendance data: $e');
        // In case of error, reset to safe default values
        setState(() {
          clockInTime = null;
          clockOutTime = null;
          isClockedIn = false;
          totalWorkingTime = "--:--:--";
          checkInLocation = null;
          checkOutLocation = null;
        });
      } finally {
        setState(() {
          isDataLoading = false;
        });
      }
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')} hours";
  }


  Future<void> handleClockInOut() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Get location
      await _getCurrentPosition();

      if (currentPosition == null || currentAddress == null || googleMapsUrl == null) {
        _showErrorSnackBar('Failed to get location information');
        return;
      }

      // Record attendance via API
      final response = await AttendanceService.recordAttendance(
        address: currentAddress!,
        addressLink: googleMapsUrl!,
      );

      if (response.success) {
        if (isClockedIn) {
          // Clock Out
          clockOutTime = DateTime.now();
        } else {
          // Clock In
          clockInTime = DateTime.now();
        }

        setState(() {
          isClockedIn = !isClockedIn;
        });

        // Refresh both attendance data and daily records
        await Future.wait([
          _fetchAttendanceData(),
          _fetchDailyAttendance(),
        ]);
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      debugPrint('Error during clock in/out: $e');
      _showErrorSnackBar('An error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _fetchDailyAttendance() async {
    setState(() {
      isDailyDataLoading = true;
    });

    try {
      final userData = await AuthService.getCurrentUser();
      if (userData == null) {
        debugPrint('No user data available');
        return;
      }

      final today = DateTime.now();
      final formattedDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final dailyData = await AttendanceService.getDailyAttendance(
        userData.employeeId,
        formattedDate,
      );

      if (dailyData != null && dailyData['records'] != null) {
        setState(() {
          dailyRecords = List<Map<String, dynamic>>.from(dailyData['records']);
        });
      }
    } catch (e) {
      debugPrint('Error fetching daily attendance: $e');
    } finally {
      setState(() {
        isDailyDataLoading = false;
      });
    }
  }


  /**
   * Component function section 
   */
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentPosition();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildClockButton() {
    final bool canClockInOut = !isLoading && !isDataLoading;
    
    // Determine button color and text
    final Color buttonColor = isClockedIn ? Colors.black : Colors.red;
    final String buttonText = isClockedIn ? "CLOCK OUT" : "CLOCK IN";
    final String loadingText = isClockedIn ? "Processing Clock Out..." : "Processing Clock In...";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(double.infinity, 50),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(80),
        ),
        onPressed: canClockInOut ? handleClockInOut : null,
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loadingText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : Text(
                buttonText,
                style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                ),
              ),
      ),
    );
}

  

  @override
  Widget build(BuildContext context) {
    Color textColor = _elapsedSeconds >= 28800 ? Colors.green : const Color.fromARGB(255, 255, 2, 2); 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color.fromRGBO(204, 0, 0, 1.0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset(
              'assets/logoptap.png',
              width: 50,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clock In Button Section
            _buildClockButton(),

            // Total Working Hours Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: isDataLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment:
                              MainAxisAlignment.center,
                            children: [
                              Icon(Icons.work, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "Total working hour",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          Center(
                            child: Text(
                              totalWorkingTime,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                          const Divider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Clock in: ${clockInTime != null ? clockInTime!.toLocal().toString().split(' ')[1].split('.')[0] : '--:--:--'}",
                                  ),
                                  Text(
                                    "Clock out: ${clockOutTime != null ? clockOutTime!.toLocal().toString().split(' ')[1].split('.')[0] : '--:--:--'}",
                                  ),
                                ],
                              ),
                              if (checkInLocation != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  "Check-in location: $checkInLocation",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                              if (checkOutLocation != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Check-out location: $checkOutLocation",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
              ),
            ),

            // Daily Report Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Daily Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (isDailyDataLoading)
              const Center(child: CircularProgressIndicator())
            else if (dailyRecords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No attendance records found')),
              )
            else
              ...dailyRecords.map((record) => DailyReportCard(record: record)),

            // Summary Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SummaryCard(
                      label: 'Working Days',
                      value: '00 days',
                      color: Colors.blue),
                  SummaryCard(
                      label: 'On Leave',
                      value: '00 days',
                      color: Colors.orange),
                  SummaryCard(
                      label: 'Absent', value: '00 days', color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyReportCard extends StatelessWidget {
  final Map<String, dynamic> record;

  const DailyReportCard({
    Key? key,
    required this.record,
  }) : super(key: key);

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) return '--:--:--';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:'
          '${dateTime.minute.toString().padLeft(2, '0')}:'
          '${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkInTime = _formatTime(record['check_in']);
    final checkOutTime = _formatTime(record['check_out']);
    final checkInLocation = record['check_in_location']?['address'] ?? '';
    final deviceInfo = record['device_info'] ?? {};

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              color: Colors.black,
              child: Center(
                child: Text(
                  checkInTime.substring(0, 5),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Clock In: $checkInTime'),
                  Text('Clock Out: $checkOutTime'),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: $checkInLocation'),
                const SizedBox(height: 4),
                Text('Device: ${deviceInfo['browser'] ?? 'Unknown'} on ${deviceInfo['os'] ?? 'Unknown'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  SummaryCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 8),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 16)),
          Spacer(),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}