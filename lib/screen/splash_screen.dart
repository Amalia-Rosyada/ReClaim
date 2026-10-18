import 'dart:async';
import 'package:flutter/material.dart';

import 'login_screen.dart';

// ==================== WARNA ====================

const Color primaryBlue = Color(0xFF3989E8);
const Color darkBlue = Color(0xFF17345F);
const Color lightBlue = Color(0xFFEAF4FF);
const Color textBlue = Color(0xFF54749E);

// ==================== SPLASH SCREEN ====================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dekorasi atas
          Positioned(
            top: -80,
            left: -60,
            child: _circleDecoration(220),
          ),

          Positioned(
            top: 20,
            right: -80,
            child: _circleDecoration(180),
          ),

          // Dekorasi bawah
          Positioned(
            bottom: -90,
            left: -40,
            child: _circleDecoration(230),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Logo PNG ReClaim
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 18),

                const Text(
                  'ReClaim',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Temukan. Kembalikan.',
                  style: TextStyle(
                    fontSize: 18,
                    color: textBlue,
                  ),
                ),

                const Text(
                  'Jadi lebih baik.',
                  style: TextStyle(
                    fontSize: 18,
                    color: textBlue,
                  ),
                ),

                const SizedBox(height: 45),

                // Ilustrasi sederhana
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.backpack_rounded,
                      size: 100,
                      color: primaryBlue,
                    ),
                    SizedBox(width: 15),
                    Icon(
                      Icons.key_rounded,
                      size: 55,
                      color: Color(0xFF69A7ED),
                    ),
                  ],
                ),

                const Spacer(),

                // Loading
                const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: primaryBlue,
                  ),
                ),

                const SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleDecoration(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: lightBlue,
        shape: BoxShape.circle,
      ),
    );
  }
}
