import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    if (_isLoggingIn) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Cek input kosong
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan password harus diisi.');
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      final hasAccount = prefs.getBool('has_account') ?? false;

      // Belum ada akun
      if (!hasAccount) {
        if (!mounted) return;

        setState(() {
          _isLoggingIn = false;
        });

        _showMessage('Belum ada akun. Silakan daftar terlebih dahulu.');
        return;
      }

      final savedEmail = prefs.getString('user_email') ?? '';

      final savedPassword = prefs.getString('user_password') ?? '';

      // Cek email dan password
      if (email != savedEmail || password != savedPassword) {
        if (!mounted) return;

        setState(() {
          _isLoggingIn = false;
        });

        _showMessage('Email atau password salah.');
        return;
      }

      // Login berhasil
      await prefs.setBool('is_logged_in', true);

      if (!mounted) return;

      _showMessage('Login berhasil.');

      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoggingIn = false;
      });

      _showMessage('Terjadi kesalahan saat login.');
    }
  }

  // ============================================================
  // PESAN
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

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
              // ==================================================
              // LOGO
              // ==================================================

              const Center(child: ReClaimLogo(size: 75)),

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

              // ==================================================
              // JUDUL
              // ==================================================
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
                style: TextStyle(fontSize: 16, color: textBlue),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // EMAIL
              // ==================================================
              _emailInputField(),

              const SizedBox(height: 16),

              // ==================================================
              // PASSWORD
              // ==================================================
              _passwordInputField(),

              const SizedBox(height: 12),

              // ==================================================
              // LUPA PASSWORD
              // ==================================================
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showMessage('Fitur lupa password belum tersedia.');
                  },
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

              // ==================================================
              // TOMBOL MASUK
              // ==================================================
              _mainButton(
                title: _isLoggingIn ? 'Memeriksa...' : 'Masuk',
                onPressed: _isLoggingIn ? null : _login,
              ),

              const SizedBox(height: 25),

              // ==================================================
              // ATAU
              // ==================================================
              _orDivider(),

              const SizedBox(height: 20),

              // ==================================================
              // GOOGLE
              // ==================================================
              _googleButton(title: 'Masuk dengan Google'),

              const SizedBox(height: 30),

              // ==================================================
              // DAFTAR
              // ==================================================
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: textBlue),
                    ),
                    GestureDetector(
                      onTap: _isLoggingIn
                          ? null
                          : () {
                              Navigator.pushNamed(context, '/register');
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

  // ============================================================
  // EMAIL FIELD
  // TIDAK ADA IKON MATA
  // ============================================================

  Widget _emailInputField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: textBlue),

        prefixIcon: const Icon(Icons.email_outlined, color: darkBlue),

        // TIDAK ADA suffixIcon
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // IKON MATA SELALU ADA
  // ============================================================

  Widget _passwordInputField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: textBlue),

        prefixIcon: const Icon(Icons.lock_outline, color: darkBlue),

        // IKON MATA SELALU ADA
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: darkBlue,
          ),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  // ============================================================
  // TOMBOL UTAMA
  // ============================================================

  Widget _mainButton({
    required String title,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primaryBlue.withValues(alpha: 0.6),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ============================================================
  // GOOGLE BUTTON
  // ============================================================

  Widget _googleButton({required String title}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: () {
          _showMessage('Login dengan Google belum tersedia.');
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: darkBlue,
          side: const BorderSide(color: Color(0xFFD8E5F3)),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // OR DIVIDER
  // ============================================================

  Widget _orDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFD8E5F3))),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('atau', style: TextStyle(color: textBlue)),
        ),

        const Expanded(child: Divider(color: Color(0xFFD8E5F3))),
      ],
    );
  }
}
