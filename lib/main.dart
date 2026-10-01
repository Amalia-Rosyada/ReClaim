import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ReClaimApp());
}

class ReClaimApp extends StatelessWidget {
  const ReClaimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReClaim',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3989E8),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

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

// ==================== LOGIN ====================

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 35, 28, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: ReClaimLogo(size: 75),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'ReClaim',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ),

              const SizedBox(height: 45),

              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Masuk untuk melanjutkan ke akun Anda.',
                style: TextStyle(
                  fontSize: 16,
                  color: textBlue,
                ),
              ),

              const SizedBox(height: 30),

              _inputField(
                icon: Icons.email_outlined,
                hint: 'Email',
              ),

              const SizedBox(height: 16),

              _inputField(
                icon: Icons.lock_outline,
                hint: 'Password',
                obscure: true,
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              _mainButton(
                title: 'Masuk',
                onPressed: () {},
              ),

              const SizedBox(height: 25),

              _orDivider(),

              const SizedBox(height: 20),

              _googleButton(
                title: 'Masuk dengan Google',
              ),

              const SizedBox(height: 30),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: textBlue),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== REGISTER ====================

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 25, 28, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Buat akun baru untuk mulai\nmenggunakan ReClaim.',
                style: TextStyle(
                  fontSize: 16,
                  color: textBlue,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              _inputField(
                icon: Icons.person_outline,
                hint: 'Nama Lengkap',
              ),

              const SizedBox(height: 16),

              _inputField(
                icon: Icons.email_outlined,
                hint: 'Email',
              ),

              const SizedBox(height: 16),

              _inputField(
                icon: Icons.lock_outline,
                hint: 'Password',
                obscure: true,
              ),

              const SizedBox(height: 16),

              _inputField(
                icon: Icons.lock_outline,
                hint: 'Konfirmasi Password',
                obscure: true,
              ),

              const SizedBox(height: 25),

              _mainButton(
                title: 'Daftar',
                onPressed: () {},
              ),

              const SizedBox(height: 25),

              _orDivider(),

              const SizedBox(height: 20),

              _googleButton(
                title: 'Daftar dengan Google',
              ),

              const SizedBox(height: 30),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: textBlue),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

// ==================== KOMPONEN INPUT ====================

Widget _inputField({
  required IconData icon,
  required String hint,
  bool obscure = false,
}) {
  return TextField(
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: textBlue,
      ),
      prefixIcon: Icon(
        icon,
        color: darkBlue,
      ),
      suffixIcon: obscure
          ? const Icon(
              Icons.visibility_outlined,
              color: darkBlue,
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFD8E5F3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFD8E5F3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.5,
        ),
      ),
    ),
  );
}

// ==================== TOMBOL UTAMA ====================

Widget _mainButton({
  required String title,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ==================== GOOGLE BUTTON ====================

Widget _googleButton({
  required String title,
}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: darkBlue,
        side: const BorderSide(
          color: Color(0xFFD8E5F3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 23,
            height: 23,
            alignment: Alignment.center,
            child: const Text(
              'G',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

// ==================== OR DIVIDER ====================

Widget _orDivider() {
  return Row(
    children: [
      const Expanded(
        child: Divider(
          color: Color(0xFFD8E5F3),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          'atau',
          style: TextStyle(
            color: textBlue,
          ),
        ),
      ),
      const Expanded(
        child: Divider(
          color: Color(0xFFD8E5F3),
        ),
      ),
    ],
  );
}
