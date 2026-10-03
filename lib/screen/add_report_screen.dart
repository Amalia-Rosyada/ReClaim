import 'package:flutter/material.dart';

import 'splash_screen.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  String _reportType = 'Hilang';

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_itemController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan lengkapi semua data terlebih dahulu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _reportType == 'Hilang'
              ? 'Laporan barang hilang berhasil dibuat.'
              : 'Laporan barang ditemukan berhasil dibuat.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  Widget _buildTypeButton({
    required String title,
    required IconData icon,
  }) {
    final bool selected = _reportType == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _reportType = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? lightBlue : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? primaryBlue : Colors.grey.shade300,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: selected ? primaryBlue : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? primaryBlue : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: primaryBlue,
        ),
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 1.5,
          ),
        ),
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkBlue,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tambah Laporan',
          style: TextStyle(
            color: darkBlue,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            const Text(
              'Buat Laporan',
              style: TextStyle(
                color: darkBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Bantu orang lain menemukan atau mengembalikan barang.',
              style: TextStyle(
                color: textBlue,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            // Jenis laporan
            const Text(
              'Jenis Laporan',
              style: TextStyle(
                color: darkBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _buildTypeButton(
                  title: 'Hilang',
                  icon: Icons.search_off_rounded,
                ),
                const SizedBox(width: 12),
                _buildTypeButton(
                  title: 'Ditemukan',
                  icon: Icons.inventory_2_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Nama barang
            _buildTextField(
              controller: _itemController,
              label: 'Nama Barang',
              hint: 'Contoh: Dompet cokelat',
              icon: Icons.inventory_2_outlined,
            ),

            const SizedBox(height: 16),

            // Lokasi
            _buildTextField(
              controller: _locationController,
              label: 'Lokasi',
              hint: 'Contoh: Gedung FKIP',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 16),

            // Deskripsi
            _buildTextField(
              controller: _descriptionController,
              label: 'Deskripsi Barang',
              hint: 'Jelaskan ciri-ciri atau kondisi barang...',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            // Foto
            const Text(
              'Foto Barang',
              style: TextStyle(
                color: darkBlue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryBlue.withValues(alpha: 0.3),
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur tambah foto belum tersedia.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 34,
                      color: primaryBlue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambah Foto',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Tambahkan foto agar barang lebih mudah dikenali',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textBlue,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol kirim
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Kirim Laporan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}