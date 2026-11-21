import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  // MEMBACA LAPORAN YANG TERSIMPAN
  Future<void> _loadReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedReports = prefs.getStringList('user_reports') ?? [];

      final reports = <Map<String, dynamic>>[];

      for (final report in savedReports) {
        try {
          final decoded = jsonDecode(report);

          if (decoded is Map<String, dynamic>) {
            reports.add(decoded);
          }
        } catch (_) {
          // Lewati data laporan yang tidak valid.
        }
      }

      // Laporan terbaru ditampilkan terlebih dahulu.
      reports.sort((a, b) {
        final dateA =
            DateTime.tryParse(a['date']?.toString() ?? '') ??
                DateTime(2000);
        final dateB =
            DateTime.tryParse(b['date']?.toString() ?? '') ??
                DateTime(2000);

        return dateB.compareTo(dateA);
      });

      if (!mounted) return;

      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route).then((_) {
      if (mounted) {
        _loadReports();
      }
    });
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Waktu tidak diketahui';
    }

    final date = DateTime.tryParse(value);

    if (date == null) return value;

    final difference = DateTime.now().difference(date);

    if (difference.isNegative || difference.inMinutes < 1) {
      return 'Baru saja';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    }
    if (difference.inDays == 1) {
      return 'Kemarin';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              'ReClaim',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _goTo(context, '/notification'),
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // BODY
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadReports,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Selamat datang! 👋',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Temukan kembali barang yang hilang '
                  'atau bantu orang lain menemukan barangnya.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                // SEARCH
                GestureDetector(
                  onTap: () => _goTo(context, '/search'),
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: primaryBlue,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cari barang...',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // MENU
                Row(
                  children: [
                    Expanded(
                      child: _MenuCard(
                        icon: Icons.search_rounded,
                        title: 'Cari Barang',
                        subtitle: 'Temukan barang',
                        onTap: () => _goTo(context, '/search'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MenuCard(
                        icon: Icons.add_rounded,
                        title: 'Tambah Laporan',
                        subtitle: 'Laporkan barang',
                        onTap: () => _goTo(context, '/add-report'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // LAPORAN TERBARU
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan Terbaru',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _goTo(context, '/search'),
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

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_reports.isEmpty)
                  _buildEmptyReports(context)
                else
                  ..._reports.map((report) {
                    final type = report['type']?.toString() ?? 'Hilang';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ReportCard(
                        title: report['item']?.toString() ?? 'Barang',
                        location:
                            report['location']?.toString() ??
                                'Lokasi tidak tersedia',
                        time: _formatDate(
                          report['date']?.toString(),
                        ),
                        status: type,
                        description:
                            report['description']?.toString() ?? '',
                        imageData: report['imageData']?.toString() ?? '',
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: primaryBlue,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 10,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              _goTo(context, '/search');
              break;
            case 2:
              _goTo(context, '/add-report');
              break;
            case 3:
              _goTo(context, '/notification');
              break;
            case 4:
              _goTo(context, '/profile');
              break;
          }
        },
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

  // ============================================================
  // TAMPILAN KETIKA BELUM ADA LAPORAN
  // ============================================================

  Widget _buildEmptyReports(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 42,
            color: primaryBlue,
          ),
          const SizedBox(height: 10),
          Text(
            'Belum ada laporan',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Laporan yang kamu buat akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MENU CARD
// ============================================================

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// KARTU LAPORAN
// ============================================================

class _ReportCard extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String status;
  final String description;
  final String imageData;

  const _ReportCard({
    required this.title,
    required this.location,
    required this.time,
    required this.status,
    required this.description,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLost = status == 'Hilang';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // IKON BARANG
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: imageData.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      base64Decode(imageData),
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        isLost
                            ? Icons.search_off_rounded
                            : Icons.inventory_2_outlined,
                        color: primaryBlue,
                        size: 30,
                      ),
                    ),
                  )
                : Icon(
                    isLost
                        ? Icons.search_off_rounded
                        : Icons.inventory_2_outlined,
                    color: primaryBlue,
                    size: 30,
                  ),
          ),

          const SizedBox(width: 14),

          // INFORMASI BARANG
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isLost
                  ? const Color(0xFFFFF1F1)
                  : const Color(0xFFEFFAF2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isLost ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
