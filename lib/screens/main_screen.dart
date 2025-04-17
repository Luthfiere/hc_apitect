import 'package:flutter/material.dart';
import 'home_page.dart';
import 'attendance_page.dart';
import 'timesheets.dart';
import 'notification.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AttendancePage(),
    const TimeSheetPage(),
    const NotificationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Tambahkan ini
        backgroundColor: Colors.black, // Warna latar belakang hitam
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: "Attendance"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Time Sheets"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_important_outlined),
              label: "Notification"),
        ],
      ),
    );
  }
}
