import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';
import '../theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeController themeController;

  const SettingsScreen({
    super.key,
    required this.themeController,
  });

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

  // Menampilkan pilihan tema Terang dan Gelap.
  void _showThemeOptions() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedTheme = widget.themeController.themeMode;

            return AlertDialog(
              title: const Text(
                'Penampilan Tema',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: selectedTheme,
                    activeColor: primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Terang'),
                    subtitle: const Text(
                      'Gunakan tampilan terang.',
                    ),
                    secondary: const Icon(Icons.light_mode_outlined),
                    onChanged: (value) async {
                      if (value == null) return;

                      await widget.themeController.setThemeMode(value);

                      if (!mounted) return;

                      setDialogState(() {});
                      Navigator.pop(dialogContext);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: selectedTheme,
                    activeColor: primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Gelap'),
                    subtitle: const Text(
                      'Gunakan tampilan gelap.',
                    ),
                    secondary: const Icon(Icons.dark_mode_outlined),
                    onChanged: (value) async {
                      if (value == null) return;

                      await widget.themeController.setThemeMode(value);

                      if (!mounted) return;

                      setDialogState(() {});
                      Navigator.pop(dialogContext);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Tutup',
                    style: TextStyle(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAccountInfo() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Informasi Akun',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _name,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Email',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                style: TextStyle(
                  color: colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final currentThemeName =
        widget.themeController.isDarkMode ? 'Gelap' : 'Terang';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
        ),
        title: Text(
          'Pengaturan',
          style: TextStyle(
            color: colorScheme.onSurface,
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
                  Text(
                    'Preferensi',
                    style: TextStyle(
                      color: colorScheme.onSurface,
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

                  const SizedBox(height: 12),

                  _buildSettingCard(
                    icon: Icons.palette_outlined,
                    title: 'Penampilan Tema',
                    subtitle: 'Tema saat ini: $currentThemeName',
                    onTap: _showThemeOptions,
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'Akun',
                    style: TextStyle(
                      color: colorScheme.onSurface,
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

                  Text(
                    'Tentang',
                    style: TextStyle(
                      color: colorScheme.onSurface,
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

                  Center(
                    child: Text(
                      'ReClaim v1.0.0',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: colorScheme.surface,
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
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? colorScheme.primary.withOpacity(0.15)
                      : lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              if (trailing != null)
                trailing
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
