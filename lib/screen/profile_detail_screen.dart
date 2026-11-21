import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  String _phone = '';
  String _name = '';
  String _gender = '';
  String _birthDate = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // MEMUAT DATA PROFIL
  // ============================================================

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _phone = prefs.getString('user_phone') ?? '';
      _name = prefs.getString('user_name') ?? '';
      _gender = prefs.getString('user_gender') ?? '';
      _birthDate = prefs.getString('user_birthdate') ?? '';
      _email = prefs.getString('user_email') ?? '';
    });
  }

  // ============================================================
  // MENYIMPAN DATA PROFIL
  // ============================================================

  Future<void> _saveProfile(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);

    await _loadProfile();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data profil berhasil diperbarui.'),
      ),
    );
  }

  // ============================================================
  // MENGUBAH DATA TEKS
  // ============================================================

  Future<void> _editText({
    required String title,
    required String key,
    required String currentValue,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController(
      text: currentValue,
    );

    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Ubah $title'),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: Theme.of(dialogContext).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (value == null || value.isEmpty) return;

    await _saveProfile(key, value);
  }

  // ============================================================
  // MENGUBAH JENIS KELAMIN
  // ============================================================

  Future<void> _editGender() async {
    final selectedGender = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Pilih Jenis Kelamin'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'Laki-laki');
              },
              child: const Text('Laki-laki'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'Perempuan');
              },
              child: const Text('Perempuan'),
            ),
          ],
        );
      },
    );

    if (selectedGender == null) return;

    await _saveProfile('user_gender', selectedGender);
  }

  // ============================================================
  // MENGUBAH TANGGAL LAHIR
  // ============================================================

  Future<void> _editBirthDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;

    final formattedDate =
        '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year}';

    await _saveProfile('user_birthdate', formattedDate);
  }

  // ============================================================
  // HAPUS PROFIL
  // ============================================================

  Future<void> _deleteProfile() async {
    // Memeriksa apakah ada data profil yang sudah diisi.
    final hasProfileData = _phone.trim().isNotEmpty ||
        _name.trim().isNotEmpty ||
        _gender.trim().isNotEmpty ||
        _birthDate.trim().isNotEmpty ||
        _email.trim().isNotEmpty;

    // Jika semua data masih kosong, penghapusan tidak dilakukan.
    if (!hasProfileData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Belum ada data profil yang dapat dihapus.',
          ),
        ),
      );
      return;
    }

    // Dialog konfirmasi penghapusan.
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Profil'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus seluruh '
            'data profil yang telah diisi?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    // Menghapus data profil saja.
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('user_gender');
    await prefs.remove('user_birthdate');

    // Memuat ulang tampilan setelah data dihapus.
    await _loadProfile();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data profil berhasil dihapus.'),
      ),
    );
  }

  // ============================================================
  // FORMAT DATA KOSONG
  // ============================================================

  String _displayValue(String value) {
    return value.trim().isEmpty
        ? 'Data belum diisi'
        : value;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Profil',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),

              // NOMOR TELEPON
              _profileItem(
                context: context,
                icon: Icons.phone_outlined,
                title: 'Nomor telepon',
                value: _displayValue(_phone),
                onTap: () {
                  _editText(
                    title: 'Nomor telepon',
                    key: 'user_phone',
                    currentValue: _phone,
                    keyboardType: TextInputType.phone,
                  );
                },
              ),

              // NAMA LENGKAP
              _profileItem(
                context: context,
                icon: Icons.person_outline_rounded,
                title: 'Nama lengkap',
                value: _displayValue(_name),
                onTap: () {
                  _editText(
                    title: 'Nama lengkap',
                    key: 'user_name',
                    currentValue: _name,
                  );
                },
              ),

              // JENIS KELAMIN
              _profileItem(
                context: context,
                icon: Icons.wc_outlined,
                title: 'Jenis kelamin',
                value: _displayValue(_gender),
                onTap: _editGender,
              ),

              // TANGGAL LAHIR
              _profileItem(
                context: context,
                icon: Icons.calendar_month_outlined,
                title: 'Tanggal lahir',
                value: _displayValue(_birthDate),
                onTap: _editBirthDate,
              ),

              // EMAIL
              _profileItem(
                context: context,
                icon: Icons.mail_outline_rounded,
                title: 'Email',
                value: _displayValue(_email),
                onTap: () {
                  _editText(
                    title: 'Email',
                    key: 'user_email',
                    currentValue: _email,
                    keyboardType: TextInputType.emailAddress,
                  );
                },
              ),

              const SizedBox(height: 12),

              // HAPUS PROFIL
              InkWell(
                onTap: _deleteProfile,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                      SizedBox(width: 24),
                      Text(
                        'Hapus profil',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // WIDGET ITEM INFORMASI PROFIL
  // ============================================================

  Widget _profileItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 22,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 30,
            ),

            const SizedBox(width: 24),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    value,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
