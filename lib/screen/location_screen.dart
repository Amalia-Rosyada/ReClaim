import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static const Color primaryBlue = Color(0xFF3989E8);

  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _cities = [];

  String? _provinceId;
  String? _provinceName;
  String? _cityName;

  double? _latitude;
  double? _longitude;

  bool _loadingProvinces = true;
  bool _loadingCities = false;
  bool _gettingLocation = false;
  bool _saving = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json',
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data provinsi.');
      }

      final data = jsonDecode(response.body) as List;

      if (!mounted) return;

      setState(() {
        _provinces = data.map((e) => Map<String, dynamic>.from(e)).toList();
        _loadingProvinces = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingProvinces = false;
        _error = 'Data provinsi gagal dimuat. Periksa koneksi internet.';
      });
    }
  }

  Future<void> _loadCities(String provinceId) async {
    setState(() {
      _cities = [];
      _cityName = null;
      _loadingCities = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json',
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data kabupaten/kota.');
      }

      final data = jsonDecode(response.body) as List;

      if (!mounted) return;

      setState(() {
        _cities = data.map((e) => Map<String, dynamic>.from(e)).toList();
        _loadingCities = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingCities = false;
        _error = 'Data kabupaten/kota gagal dimuat.';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _gettingLocation = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Aktifkan GPS atau layanan lokasi HP terlebih dahulu.');
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi belum diberikan.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Izin lokasi ditolak permanen. Aktifkan melalui Pengaturan HP.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _gettingLocation = false);
      }
    }
  }

  Future<void> _continueToHome() async {
    if (_saving) return;

    if (_provinceName == null || _cityName == null) {
      setState(() {
        _error = 'Pilih provinsi dan kabupaten/kota terlebih dahulu.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user_province', _provinceName!);
      await prefs.setString('user_city', _cityName!);

      if (_latitude != null && _longitude != null) {
        await prefs.setDouble('user_latitude', _latitude!);
        await prefs.setDouble('user_longitude', _longitude!);
        await prefs.setBool('gps_location_available', true);
      } else {
        await prefs.remove('user_latitude');
        await prefs.remove('user_longitude');
        await prefs.setBool('gps_location_available', false);
      }

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'Lokasi gagal disimpan. Coba kembali.';
        _saving = false;
      });
    }
  }

  // ============================================================
  // DEKORASI INPUT
  // ============================================================

  InputDecoration _decoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
      ),
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.5,
        ),
      ),
    );
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
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Pilih Lokasi',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ILUSTRASI LOKASI
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 55,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // JUDUL
              Text(
                'Di mana lokasi kamu?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Pilih wilayah tempat kamu berada untuk '
                'membantu menemukan barang di sekitar.',
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 28),

              // PILIH WILAYAH MANUAL
              Text(
                'Pilih wilayah secara manual',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 14),

              if (_loadingProvinces)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_provinces.isEmpty)
                OutlinedButton.icon(
                  onPressed: _loadProvinces,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat ulang data wilayah'),
                )
              else
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _provinceId,
                  decoration: _decoration(
                    context,
                    'Provinsi',
                    Icons.map_outlined,
                  ),
                  hint: const Text('Pilih provinsi'),
                  items: _provinces.map((province) {
                    return DropdownMenuItem<String>(
                      value: province['id'].toString(),
                      child: Text(province['name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    final province = _provinces.firstWhere(
                      (item) => item['id'].toString() == value,
                    );

                    setState(() {
                      _provinceId = value;
                      _provinceName = province['name'].toString();
                      _cityName = null;
                      _latitude = null;
                      _longitude = null;
                    });

                    _loadCities(value);
                  },
                ),

              const SizedBox(height: 16),

              // PILIH KABUPATEN/KOTA
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _cityName,
                decoration: _decoration(
                  context,
                  'Kabupaten/Kota',
                  Icons.location_city_outlined,
                ),
                hint: Text(
                  _provinceId == null
                      ? 'Pilih provinsi terlebih dahulu'
                      : 'Pilih kabupaten/kota',
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city['name'].toString(),
                    child: Text(city['name'].toString()),
                  );
                }).toList(),
                onChanged: _provinceId == null || _loadingCities
                    ? null
                    : (value) {
                        setState(() {
                          _cityName = value;
                          _latitude = null;
                          _longitude = null;
                          _error = null;
                        });
                      },
              ),

              if (_loadingCities) ...[
                const SizedBox(height: 10),
                const LinearProgressIndicator(),
              ],

              const SizedBox(height: 28),

              // PEMISAH
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ATAU',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // TOMBOL GPS
              OutlinedButton.icon(
                onPressed: _gettingLocation ? null : _getCurrentLocation,
                icon: _gettingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _gettingLocation
                      ? 'Mendeteksi lokasi...'
                      : 'Gunakan Lokasi Saya (GPS)',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              // INFORMASI GPS BERHASIL
              if (_latitude != null && _longitude != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Lokasi GPS berhasil didapatkan.\n'
                    'Lat: ${_latitude!.toStringAsFixed(5)}\n'
                    'Long: ${_longitude!.toStringAsFixed(5)}',
                    style: TextStyle(
                      color: colorScheme.onTertiaryContainer,
                      height: 1.6,
                    ),
                  ),
                ),
              ],

              // PESAN ERROR
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // TOMBOL LANJUTKAN
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _continueToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _saving ? 'Menyimpan...' : 'Lanjutkan ke Beranda',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
