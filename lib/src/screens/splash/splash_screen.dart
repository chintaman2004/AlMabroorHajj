// ignore_for_file: use_build_context_synchronously

import 'package:almabroorhajj/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Show splash screen for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    final auth = Provider.of<MyAuthProvider>(context, listen: false);

    if (auth.currentUser != null) {
      // User is logged in
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User not logged in
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Al Mabroor Hajj",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
