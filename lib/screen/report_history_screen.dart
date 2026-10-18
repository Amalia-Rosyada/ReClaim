import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReports = prefs.getStringList('user_reports') ?? [];
    final reports = <Map<String, dynamic>>[];

    for (final report in savedReports) {
      try {
        reports.add(Map<String, dynamic>.from(jsonDecode(report) as Map));
      } catch (_) {
        // Lewati data laporan yang tidak valid.
      }
    }

    if (!mounted) return;
    setState(() {
      _reports = reports.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteReport(Map<String, dynamic> report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Laporan?'),
        content: Text(
          'Laporan "${report['item'] ?? 'Barang'}" akan dihapus dari riwayat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    final savedReports = prefs.getStringList('user_reports') ?? [];
    final reportId = report['id']?.toString() ?? '';
    var removed = false;

    savedReports.removeWhere((raw) {
      try {
        final decoded = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        final matches = reportId.isNotEmpty
            ? decoded['id']?.toString() == reportId
            : decoded['date']?.toString() == report['date']?.toString() &&
                decoded['item']?.toString() == report['item']?.toString() &&
                decoded['location']?.toString() ==
                    report['location']?.toString();
        if (matches && !removed) {
          removed = true;
          return true;
        }
      } catch (_) {
        // Biarkan data yang tidak dapat dibaca tetap ada.
      }
      return false;
    });

    await prefs.setStringList('user_reports', savedReports);
    await _loadReports();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil dihapus.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return '-';
    final date = DateTime.tryParse(value.toString());
    if (date == null) return '-';

    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ditemukan':
        return Colors.green;
      case 'selesai':
        return Colors.blue;
      default:
        return Colors.orange;
    }
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
          'Riwayat Laporan',
          style: TextStyle(
            color: darkBlue,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _reports.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 70,
                            color: textBlue.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum Ada Riwayat Laporan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: darkBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Laporan yang kamu kirim akan muncul di halaman ini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textBlue, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadReports,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _reports.length,
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        final type =
                            report['type']?.toString() ?? 'Hilang';
                        final status =
                            report['status']?.toString() ?? 'Menunggu';
                        final imageData =
                            report['imageData']?.toString() ?? '';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFFE0EAF5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: Container(
                                      width: 58,
                                      height: 58,
                                      color: lightBlue,
                                      child: imageData.isNotEmpty
                                          ? Image.memory(
                                              base64Decode(imageData),
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) =>
                                                  _reportIcon(type),
                                            )
                                          : _reportIcon(type),
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report['item']?.toString() ??
                                              'Barang tanpa nama',
                                          style: const TextStyle(
                                            color: darkBlue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Laporan $type',
                                          style: const TextStyle(
                                            color: textBlue,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(status)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: _statusColor(status),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: textBlue,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      report['location']?.toString() ?? '-',
                                      style: const TextStyle(
                                        color: textBlue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: textBlue,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    _formatDate(report['date']),
                                    style: const TextStyle(
                                      color: textBlue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                report['description']?.toString() ?? '-',
                                style: const TextStyle(
                                  color: darkBlue,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => _deleteReport(report),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Hapus laporan',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _reportIcon(String type) {
    return Icon(
      type == 'Hilang'
          ? Icons.search_off_rounded
          : Icons.inventory_2_outlined,
      color: primaryBlue,
      size: 28,
    );
  }
}
