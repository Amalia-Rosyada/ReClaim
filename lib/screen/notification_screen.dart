import 'package:flutter/material.dart';

import 'splash_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Notifikasi',
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
        child: ListView(
          padding:
              const EdgeInsets.all(24),

          children: [
            const Text(
              'Notifikasi Terbaru',
              style: TextStyle(
                color: darkBlue,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _notificationCard(
              icon: Icons.check_circle_outline,
              title:
                  'Laporan berhasil dibuat',
              message:
                  'Laporan barang kamu berhasil dikirim.',
              time: 'Baru saja',
            ),

            const SizedBox(height: 12),

            _notificationCard(
              icon: Icons.search_rounded,
              title:
                  'Ada barang yang cocok',
              message:
                  'Sistem menemukan barang yang mungkin sesuai dengan laporanmu.',
              time: '1 jam yang lalu',
            ),

            const SizedBox(height: 12),

            _notificationCard(
              icon: Icons.info_outline,
              title: 'Selamat datang di ReClaim',
              message:
                  'Gunakan ReClaim untuk melaporkan dan mencari barang hilang.',
              time: 'Hari ini',
            ),
          ],
        ),
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 3,

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
              break;

            case 4:
              Navigator.pushReplacementNamed(
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
              Icons.notifications_rounded,
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

  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String message,
    required String time,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
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
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  time,
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}