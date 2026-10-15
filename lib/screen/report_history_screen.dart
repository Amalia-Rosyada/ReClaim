
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() =>
      _ReportHistoryScreenState();
}

class _ReportHistoryScreenState
    extends State<ReportHistoryScreen> {
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
        reports.add(
          Map<String, dynamic>.from(
            jsonDecode(report) as Map,
          ),
        );
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

  String _formatDate(dynamic value) {
    if (value == null) return '-';

    final date = DateTime.tryParse(value.toString());
    if (date == null) return '-';

    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
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
                            style: TextStyle(
                              color: textBlue,
                              fontSize: 13,
                            ),
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
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius:
                                          BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      type == 'Hilang'
                                          ? Icons.search_off_rounded
                                          : Icons.inventory_2_outlined,
                                      color: primaryBlue,
                                      size: 26,
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
                                      borderRadius:
                                          BorderRadius.circular(20),
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
