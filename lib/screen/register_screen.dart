import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';
import 'auth_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isRegistering = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // DAFTAR AKUN
  // ============================================================

  Future<void> _register() async {
    if (_isRegistering) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Semua data harus diisi.');
      return;
    }

    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email)) {
      _showMessage('Format email tidak valid.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password minimal 6 karakter.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Konfirmasi password tidak sesuai.');
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      await prefs.setBool('has_account', true);

      if (!mounted) return;

      _showMessage('Akun berhasil dibuat.');

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isRegistering = false;
      });

      _showMessage('Terjadi kesalahan saat membuat akun.');
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
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOMBOL KEMBALI
                IconButton(
                  onPressed: _isRegistering
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  icon: const Icon(Icons.arrow_back_ios_new, color: darkBlue),
                ),

                const SizedBox(height: 8),

                // LOGO
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 68,
                    height: 68,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 8),

                // NAMA APLIKASI
                const Center(
                  child: Text(
                    'ReClaim',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // JUDUL
                const Text(
                  'Daftar Akun',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Buat akun baru untuk mulai menggunakan ReClaim.',
                  style: TextStyle(fontSize: 15, color: textBlue, height: 1.5),
                ),

                const SizedBox(height: 25),

                // NAMA LENGKAP
                _registerInputField(
                  controller: _nameController,
                  icon: Icons.person_outline,
                  hint: 'Nama Lengkap',
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 15),

                // EMAIL
                _registerInputField(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 15),

                // PASSWORD
                _registerInputField(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hint: 'Password',
                  obscure: _obscurePassword,
                  onVisibilityPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // KONFIRMASI PASSWORD
                _registerInputField(
                  controller: _confirmPasswordController,
                  icon: Icons.lock_outline,
                  hint: 'Konfirmasi Password',
                  obscure: _obscureConfirmPassword,
                  onVisibilityPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // TOMBOL DAFTAR
                _registerMainButton(
                  title: _isRegistering ? 'Menyimpan...' : 'Daftar',
                  onPressed: _isRegistering ? null : _register,
                ),

                const SizedBox(height: 24),

                // PEMISAH
                _registerOrDivider(),

                const SizedBox(height: 18),

                // GOOGLE
                _registerGoogleButton(
                  title: 'Daftar dengan Google',
                  onPressed: () {
                    _showMessage('Pendaftaran dengan Google belum tersedia.');
                  },
                ),

                const SizedBox(height: 25),

                // NAVIGASI KE LOGIN
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(color: textBlue),
                      ),
                      GestureDetector(
                        onTap: _isRegistering
                            ? null
                            : () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
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
      ),
    );
  }
}

// ============================================================
// INPUT FIELD
// ============================================================

Widget _registerInputField({
  required TextEditingController controller,
  required IconData icon,
  required String hint,
  bool obscure = false,
  VoidCallback? onVisibilityPressed,
  TextInputType? keyboardType,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: textBlue, fontSize: 14),
      prefixIcon: Icon(icon, color: darkBlue, size: 21),
      suffixIcon: onVisibilityPressed != null
          ? IconButton(
              onPressed: onVisibilityPressed,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: darkBlue,
                size: 21,
              ),
            )
          : null,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.96),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
    ),
  );
}

// ============================================================
// TOMBOL DAFTAR
// ============================================================

Widget _registerMainButton({
  required String title,
  required VoidCallback? onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: primaryBlue.withValues(alpha: 0.6),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// ============================================================
// TOMBOL GOOGLE
// ============================================================

Widget _registerGoogleButton({
  required String title,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 53,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: darkBlue,
        backgroundColor: Colors.white.withValues(alpha: 0.92),
        side: const BorderSide(color: Color(0xFFD8E5F3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'G',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4285F4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

// ============================================================
// PEMISAH
// ============================================================

Widget _registerOrDivider() {
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
