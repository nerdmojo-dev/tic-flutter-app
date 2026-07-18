import 'package:flutter/material.dart';
import 'package:tic_task_app/shared/AppColors.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                padding: const EdgeInsets.all(20),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.15),
                  boxShadow: [AppColors.shadowLg],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image(image: AssetImage("lib/assets/logo.jpg")),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Topgrip instruments\nCompany",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Employee Status Portal",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
