
import 'package:flutter/material.dart';
import 'splash_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara melaporkan barang hilang?',
      'answer':
          'Buka menu Tambah (+), pilih jenis laporan Hilang, '
          'isi nama barang, lokasi, dan deskripsi. Setelah itu, '
          'tekan tombol Kirim Laporan.',
    },
    {
      'question': 'Bagaimana cara melaporkan barang ditemukan?',
      'answer':
          'Buka menu Tambah (+), pilih jenis laporan Ditemukan, '
          'lengkapi informasi barang dan lokasi penemuan, '
          'kemudian kirim laporan.',
    },
    {
      'question': 'Di mana saya bisa melihat laporan saya?',
      'answer':
          'Buka halaman Profil, lalu pilih Riwayat Laporan '
          'untuk melihat laporan yang pernah kamu buat.',
    },
    {
      'question': 'Apa arti status Menunggu?',
      'answer':
          'Status Menunggu menunjukkan bahwa laporan telah '
          'disimpan dan masih menunggu tindak lanjut.',
    },
    {
      'question': 'Bagaimana cara mengubah informasi akun?',
      'answer':
          'Buka halaman Profil untuk melihat informasi akun '
          'yang sedang digunakan. Fitur pengubahan data akun '
          'bergantung pada fitur yang tersedia di aplikasi.',
    },
  ];

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
          'Bantuan',
          style: TextStyle(
            color: darkBlue,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.support_agent_rounded,
                  color: primaryBlue,
                  size: 42,
                ),
                SizedBox(height: 14),
                Text(
                  'Ada yang bisa kami bantu?',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan panduan penggunaan ReClaim '
                  'dan jawaban dari pertanyaan umum di bawah ini.',
                  style: TextStyle(
                    color: textBlue,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Panduan Penggunaan',
            style: TextStyle(
              color: darkBlue,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _buildGuide(
            icon: Icons.search_rounded,
            title: 'Cari Barang',
            description:
                'Gunakan menu Pencarian untuk mencari '
                'informasi barang hilang atau ditemukan.',
          ),
          _buildGuide(
            icon: Icons.add_circle_outline_rounded,
            title: 'Buat Laporan',
            description:
                'Pilih menu Tambah (+), isi informasi barang, '
                'lalu kirim laporan.',
          ),
          _buildGuide(
            icon: Icons.history_rounded,
            title: 'Periksa Riwayat',
            description:
                'Buka Profil dan pilih Riwayat Laporan '
                'untuk memeriksa laporan yang tersimpan.',
          ),

          const SizedBox(height: 24),

          const Text(
            'Pertanyaan Umum (FAQ)',
            style: TextStyle(
              color: darkBlue,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ..._faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE0EAF5),
                ),
              ),
              child: ExpansionTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                iconColor: primaryBlue,
                collapsedIconColor: textBlue,
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  16, 0, 16, 16,
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(
                        color: textBlue,
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

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
    );
  }

  static Widget _buildGuide({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
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
                    color: darkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 12,
                    height: 1.5,
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
