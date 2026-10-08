import 'package:flutter/material.dart';

import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goTo(
    BuildContext context,
    String route,
  ) {
    Navigator.pushNamed(
      context,
      route,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ==================== APP BAR ====================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        automaticallyImplyLeading: false,

        title: const Text(
          'ReClaim',
          style: TextStyle(
            color: darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              _goTo(
                context,
                '/notification',
              );
            },

            icon: const Icon(
              Icons.notifications_none_rounded,
              color: darkBlue,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ==================== BODY ====================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            24,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Halo, selamat datang! 👋',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Temukan kembali barang yang hilang '
                'atau bantu orang lain menemukan barangnya.',
                style: TextStyle(
                  fontSize: 14,
                  color: textBlue,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              // SEARCH
              GestureDetector(
                onTap: () {
                  _goTo(
                    context,
                    '/search',
                  );
                },

                child: Container(
                  height: 54,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),

                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius:
                        BorderRadius.circular(17),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: primaryBlue,
                      ),

                      SizedBox(width: 12),

                      Text(
                        'Cari barang...',
                        style: TextStyle(
                          color: textBlue,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================== MENU ====================

              Row(
                children: [
                  Expanded(
                    child: _MenuCard(
                      icon:
                          Icons.search_rounded,
                      title: 'Cari Barang',
                      subtitle:
                          'Temukan barang',
                      color: lightBlue,

                      onTap: () {
                        _goTo(
                          context,
                          '/search',
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _MenuCard(
                      icon: Icons.add_rounded,
                      title: 'Tambah Laporan',
                      subtitle:
                          'Laporkan barang',
                      color:
                          const Color(
                        0xFFF0F7FF,
                      ),

                      onTap: () {
                        _goTo(
                          context,
                          '/add-report',
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================== LAPORAN ====================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Laporan Terbaru',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      _goTo(
                        context,
                        '/search',
                      );
                    },

                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _ReportCard(
                icon:
                    Icons.backpack_rounded,
                title: 'Tas Hitam',
                location:
                    'Gedung FKIP',
                time:
                    '2 jam yang lalu',
                status: 'Hilang',
              ),

              const SizedBox(height: 12),

              _ReportCard(
                icon: Icons.key_rounded,
                title: 'Kunci Motor',
                location:
                    'Area Kampus',
                time:
                    '5 jam yang lalu',
                status: 'Ditemukan',
              ),

              const SizedBox(height: 12),

              _ReportCard(
                icon:
                    Icons.account_balance_wallet_rounded,
                title: 'Dompet Cokelat',
                location:
                    'Perpustakaan',
                time: 'Kemarin',
                status: 'Hilang',
              ),
            ],
          ),
        ),
      ),

      // ==================== BOTTOM NAV ====================

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 0,

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
              break;

            case 1:
              _goTo(
                context,
                '/search',
              );
              break;

            case 2:
              _goTo(
                context,
                '/add-report',
              );
              break;

            case 3:
              _goTo(
                context,
                '/notification',
              );
              break;

            case 4:
              _goTo(
                context,
                '/profile',
              );
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
              Icons.person_outline_rounded,
            ),
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
        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Container(
              width: 45,
              height: 45,

              decoration:
                  const BoxDecoration(
                color: Colors.white,
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
              style: const TextStyle(
                color: darkBlue,
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              style: const TextStyle(
                color: textBlue,
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
    final bool isLost =
        status == 'Hilang';

    return Container(
      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              const Color(0xFFE0EAF5),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color: primaryBlue,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color: darkBlue,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  location,
                  style:
                      const TextStyle(
                    color: textBlue,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  time,
                  style:
                      const TextStyle(
                    color: textBlue,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: isLost
                  ? const Color(
                      0xFFFFF1F1,
                    )
                  : const Color(
                      0xFFEFFAF2,
                    ),

              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),

            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                color: isLost
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
