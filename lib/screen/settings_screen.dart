
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _name = 'Pengguna';
  String _email = '-';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;
      _name = prefs.getString('user_name') ?? 'Pengguna';
      _email = prefs.getString('user_email') ?? '-';
      _isLoading = false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('notifications_enabled', value);

    if (!mounted) return;

    setState(() {
      _notificationsEnabled = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Pengaturan notifikasi diaktifkan.'
              : 'Pengaturan notifikasi dinonaktifkan.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAccountInfo() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Informasi Akun',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama',
                style: TextStyle(color: textBlue, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                _name,
                style: const TextStyle(
                  color: darkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Email',
                style: TextStyle(color: textBlue, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                style: const TextStyle(
                  color: darkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'ReClaim',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        'assets/logo.png',
        width: 45,
        height: 45,
      ),
      children: const [
        Text(
          'ReClaim merupakan aplikasi untuk membantu pengguna '
          'melaporkan dan mencari barang hilang atau ditemukan.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkBlue,
            size: 20,
          ),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: darkBlue,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Preferensi',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildSettingCard(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifikasi',
                    subtitle: 'Pengaturan notifikasi aplikasi',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeThumbColor: primaryBlue,
                      onChanged: _toggleNotifications,
                    ),
                    onTap: () {
                      _toggleNotifications(!_notificationsEnabled);
                    },
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Akun',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildSettingCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Informasi Akun',
                    subtitle: 'Lihat nama dan email akun',
                    onTap: _showAccountInfo,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Tentang',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildSettingCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang ReClaim',
                    subtitle: 'Informasi aplikasi dan versinya',
                    onTap: _showAbout,
                  ),

                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      'ReClaim v1.0.0',
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0EAF5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: textBlue,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              if (trailing != null)
                trailing
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: textBlue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
