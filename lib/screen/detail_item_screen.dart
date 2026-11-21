import 'dart:convert';

import 'package:flutter/material.dart';

class DetailItemScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailItemScreen({
    super.key,
    required this.item,
  });

  static const Color primaryBlue = Color(0xFF3989E8);
  static const Color darkBlue = Color(0xFF173B65);
  static const Color textBlue = Color(0xFF7890AA);
  static const Color lightBlue = Color(0xFFF0F6FD);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final name = (item['name'] ?? item['item'] ?? 'Barang')
        .toString();

    final status = (item['status'] ?? item['type'] ?? 'Tidak diketahui')
        .toString();

    final location =
        (item['location'] ?? 'Lokasi tidak tersedia').toString();

    final description =
        (item['description'] ?? 'Tidak ada deskripsi barang.')
            .toString();

    final date = (item['date'] ?? item['time'] ?? 'Tidak diketahui')
        .toString();

    final imageData = item['imageData']?.toString() ?? '';
    final imagePath = item['image']?.toString() ?? '';

    final isLost = status.toLowerCase() == 'hilang';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Detail Barang',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR BARANG
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 240,
                color: colorScheme.surfaceContainerHighest,
                child: _buildItemImage(
                  context,
                  imageData,
                  imagePath,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // STATUS BARANG
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: isLost
                    ? const Color(0xFFFFF3E8)
                    : const Color(0xFFE8F7EE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isLost
                      ? const Color(0xFFE68A2E)
                      : const Color(0xFF36A269),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // NAMA BARANG
            Text(
              name,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // INFORMASI BARANG
            _sectionTitle(context, 'Informasi Barang'),

            const SizedBox(height: 15),

            _infoItem(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'Lokasi',
              value: location,
            ),

            const SizedBox(height: 18),

            _infoItem(
              context: context,
              icon: Icons.calendar_today_outlined,
              title: 'Waktu Laporan',
              value: _formatDate(date),
            ),

            const SizedBox(height: 25),

            // DESKRIPSI
            _sectionTitle(context, 'Deskripsi Barang'),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                description,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MENAMPILKAN GAMBAR BARANG
  Widget _buildItemImage(
    BuildContext context,
    String imageData,
    String imagePath,
  ) {
    if (imageData.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(imageData),
          width: double.infinity,
          height: 240,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _imagePlaceholder(context);
          },
        );
      } catch (_) {
        return _imagePlaceholder(context);
      }
    }

    if (imagePath.isNotEmpty) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder(context);
        },
      );
    }

    return _imagePlaceholder(context);
  }

  // GAMBAR PENGGANTI
  Widget _imagePlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 55,
        color: colorScheme.primary,
      ),
    );
  }

  // JUDUL BAGIAN
  Widget _sectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // INFORMASI DETAIL
  Widget _infoItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 21,
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
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // FORMAT TANGGAL
  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}'
        ' • ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
