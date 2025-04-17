import 'package:flutter/material.dart';
import '../models/attendance_record.dart';

class AttendanceProvider with ChangeNotifier {
  DateTime? _clockIn;
  DateTime? _clockOut;
  List<AttendanceRecord> _attendanceHistory = [];

  // Getters
  DateTime? get clockIn => _clockIn;
  DateTime? get clockOut => _clockOut;
  List<AttendanceRecord> get attendanceHistory => _attendanceHistory;

  // Clock In
  void clockInNow() {
    _clockIn = DateTime.now();
    _clockOut = null; // Reset clockOut if already set
    notifyListeners();
  }

  // Clock Out
  void clockOutNow() {
    if (_clockIn == null) return; // Ensure clockIn exists before clockOut

    _clockOut = DateTime.now();
    final workingDuration = _clockOut!.difference(_clockIn!);

    // Add record to history
    _attendanceHistory.add(AttendanceRecord(
      clockIn: _clockIn!,
      clockOut: _clockOut!,
      workingDuration: workingDuration,
    ));

    // Reset clockIn and clockOut
    _clockIn = null;
    _clockOut = null;
    notifyListeners();
  }
}
