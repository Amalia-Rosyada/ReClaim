import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  String _name = 'Pengguna';
  String _email = '-';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs =
        await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _name =
          prefs.getString('user_name') ??
              'Pengguna';

      _email =
          prefs.getString('user_email') ??
              '-';
    });
  }

  Future<void> _logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'is_logged_in',
      false,
    );

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Profil',
          style: TextStyle(
            color: darkBlue,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkBlue,
            size: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            children: [
              // FOTO PROFIL
              Container(
                width: 90,
                height: 90,

                decoration:
                    const BoxDecoration(
                  color: lightBlue,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.person_rounded,
                  size: 50,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                _name,
                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 21,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _email,
                style: const TextStyle(
                  color: textBlue,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              // MENU
              _profileMenu(
                icon:
                    Icons.history_rounded,
                title: 'Riwayat Laporan',
                onTap: () {
                  _showMessage(
                    'Halaman riwayat akan dibuat selanjutnya.',
                  );
                },
              ),

              const SizedBox(height: 12),

              _profileMenu(
                icon:
                    Icons.settings_outlined,
                title: 'Pengaturan',
                onTap: () {
                  _showMessage(
                    'Halaman pengaturan akan dibuat selanjutnya.',
                  );
                },
              ),

              const SizedBox(height: 12),

              _profileMenu(
                icon:
                    Icons.help_outline_rounded,
                title: 'Bantuan',
                onTap: () {
                  _showMessage(
                    'Halaman bantuan akan dibuat selanjutnya.',
                  );
                },
              ),

              const SizedBox(height: 12),

              _profileMenu(
                icon:
                    Icons.logout_rounded,
                title: 'Keluar',
                iconColor: Colors.red,
                titleColor: Colors.red,
                onTap: () {
                  _showLogoutDialog();
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 4,

        type:
            BottomNavigationBarType.fixed,

        backgroundColor:
            Colors.white,

        selectedItemColor:
            primaryBlue,

        unselectedItemColor:
            textBlue,

        elevation: 10,

        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                '/home',
              );
              break;

            case 1:
              Navigator.pushReplacementNamed(
                context,
                '/search',
              );
              break;

            case 2:
              Navigator.pushNamed(
                context,
                '/add-report',
              );
              break;

            case 3:
              Navigator.pushReplacementNamed(
                context,
                '/notification',
              );
              break;

            case 4:
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon:
                Icon(Icons.home_rounded),
            label: 'Beranda',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.search_rounded),
            label: 'Pencarian',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_rounded,
            ),
            label: 'Tambah',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_none_rounded,
            ),
            label: 'Notifikasi',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ==================== PROFILE MENU ====================

  Widget _profileMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = primaryBlue,
    Color titleColor = darkBlue,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(17),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 17,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(17),

          border: Border.all(
            color:
                const Color(0xFFE0EAF5),
          ),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              size: 15,
              color: textBlue,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== LOGOUT DIALOG ====================

  void _showLogoutDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Keluar',
          ),

          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Batal',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),

              child: const Text(
                'Keluar',
              ),
            ),
          ],
        );
      },
    );
  }
}