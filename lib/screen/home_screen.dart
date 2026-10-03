import 'package:flutter/material.dart';

import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color(0xFF3989E8);
  static const Color darkBlue = Color(0xFF17345F);
  static const Color lightBlue = Color(0xFFEAF4FF);
  static const Color textBlue = Color(0xFF54749E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ==================== APP BAR ====================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const ReClaimLogo(size: 42),
            const SizedBox(width: 10),
            const Text(
              'ReClaim',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: darkBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ==================== BODY ====================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sapaan
            const Text(
              'Halo, Selamat Datang! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Temukan kembali barangmu bersama ReClaim.',
              style: TextStyle(
                fontSize: 15,
                color: textBlue,
              ),
            ),

            const SizedBox(height: 24),

            // ==================== SEARCH ====================

            GestureDetector(
              onTap: () {},
              child: Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: textBlue,
                      size: 25,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Cari barang yang hilang...',
                      style: TextStyle(
                        fontSize: 15,
                        color: textBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================== MENU UTAMA ====================

            const Text(
              'Apa yang ingin kamu lakukan?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _MenuCard(
                    icon: Icons.search_rounded,
                    title: 'Cari Barang',
                    subtitle: 'Temukan barang',
                    color: primaryBlue,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuCard(
                    icon: Icons.add_box_rounded,
                    title: 'Tambah Laporan',
                    subtitle: 'Laporkan barang',
                    color: darkBlue,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==================== LAPORAN TERBARU ====================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Laporan Terbaru',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Contoh laporan
            _ReportCard(
              icon: Icons.backpack_rounded,
              title: 'Tas Hitam',
              location: 'Gedung FKIP',
              time: '2 jam yang lalu',
              status: 'Hilang',
            ),

            const SizedBox(height: 12),

            _ReportCard(
              icon: Icons.key_rounded,
              title: 'Kunci Motor',
              location: 'Area Kampus',
              time: '5 jam yang lalu',
              status: 'Ditemukan',
            ),

            const SizedBox(height: 12),

            _ReportCard(
              icon: Icons.account_balance_wallet_rounded,
              title: 'Dompet Cokelat',
              location: 'Perpustakaan',
              time: 'Kemarin',
              status: 'Hilang',
            ),
          ],
        ),
      ),

      // ==================== BOTTOM NAVIGATION ====================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textBlue,
        elevation: 10,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Pencarian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ==================== MENU CARD ====================

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== REPORT CARD ====================

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String location;
  final String time;
  final String status;

  const _ReportCard({
    required this.icon,
    required this.title,
    required this.location,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF3989E8);
    const darkBlue = Color(0xFF17345F);
    const textBlue = Color(0xFF54749E);

    final bool isFound = status == 'Ditemukan';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD8E5F3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: textBlue,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: textBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textBlue,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isFound
                  ? const Color(0xFFE8F7EE)
                  : const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isFound
                    ? const Color(0xFF2E8B57)
                    : const Color(0xFFE05252),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
