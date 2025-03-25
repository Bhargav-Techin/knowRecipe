import 'package:flutter/material.dart';
import 'package:recipedekhoapp/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StorageService storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

Future<void> _checkLoginStatus() async {
  String? token = await storageService.getJwt(); // Get stored JWT

  if (mounted) { // Check if widget is still active
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home'); // Go to Home
    } else {
      Navigator.pushReplacementNamed(context, '/auth'); // Go to Auth
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}
