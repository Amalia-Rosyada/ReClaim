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

                // Logo
                const ReClaimLogo(size: 100),

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

// ==================== LOGO RECLAIM ====================

class ReClaimLogo extends StatelessWidget {
  final double size;

  const ReClaimLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran kaca pembesar
          Container(
            width: size * 0.72,
            height: size * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: darkBlue,
                width: size * 0.09,
              ),
            ),
          ),

          // Barang di dalam kaca pembesar
          Icon(
            Icons.inventory_2_rounded,
            size: size * 0.28,
            color: primaryBlue,
          ),

          // Gagang kaca pembesar
          Positioned(
            right: size * 0.02,
            bottom: size * 0.04,
            child: Transform.rotate(
              angle: -0.75,
              child: Container(
                width: size * 0.38,
                height: size * 0.09,
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // Efek pencarian
          Positioned(
            right: size * 0.01,
            top: size * 0.05,
            child: Icon(
              Icons.auto_awesome,
              size: size * 0.22,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}