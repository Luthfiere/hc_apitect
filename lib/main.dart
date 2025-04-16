import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:secondly/screens/onboarding_screen.dart';
import 'package:secondly/screens/main_screen.dart';
import 'package:secondly/service/auth_service.dart';
import 'package:secondly/service/http_request.dart'; // <--- Tambahan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (!kIsWeb && Platform.isAndroid) {
      await loadCertificate();
      HttpOverrides.global = MyHttpOverrides();
    }
    // Initialize auth service
    await AuthService.init();
  } catch (e) {
    print('Initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _loginCheckFuture;

  @override
  void initState() {
    super.initState();
    _loginCheckFuture = _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    try {
      return await AuthService.isLoggedIn();
    } catch (e) {
      print('Login check error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _loginCheckFuture,
        builder: (context, snapshot) {
          // Show loading indicator while checking
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Handle errors or not logged in state
          if (snapshot.hasError || snapshot.data != true) {
            return const OnboardingScreen();
          }
          // User is logged in
          return const MainScreen();
        },
      ),
    );
  }
}
