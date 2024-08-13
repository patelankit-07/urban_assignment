import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_assignment/utils/landing_screen/landing_screens.dart';
import 'package:urban_assignment/utils/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAll(const LandingScreen()); // Navigate to landing screen if user is logged in
    } else {
      Get.offAll(const LoginScreen()); // Navigate to login screen if user is not logged in
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Urban Culture",
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
    );
  }
}
