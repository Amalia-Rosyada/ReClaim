
import 'package:flutter/material.dart';
import 'splash_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'Semua';

  // DATA BARANG SEMENTARA
  final List<Map<String, String>> _items = [
    {
      'name': 'Tas Hitam',
      'location': 'Gedung FKIP',
      'time': '2 jam yang lalu',
      'status': 'Hilang',
      'image': 'assets/tas hitam.png',
    },
    {
      'name': 'Kunci Motor',
      'location': 'Area Kampus',
      'time': '5 jam yang lalu',
      'status': 'Ditemukan',
      'image': 'assets/kunci motor.png',
    },
    {
      'name': 'Dompet Cokelat',
      'location': 'Perpustakaan',
      'time': 'Kemarin',
      'status': 'Hilang',
      'image': 'assets/dompet coklat.png',
    },
    {
      'name': 'Botol Minum',
      'location': 'Laboratorium PTI',
      'time': 'Kemarin',
      'status': 'Ditemukan',
      'image': 'assets/botol minum.png',
    },
    {
      'name': 'Flashdisk',
      'location': 'Gedung G',
      'time': '2 hari yang lalu',
      'status': 'Hilang',
      'image': 'assets/flashdisk.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // FILTER PENCARIAN
  List<Map<String, String>> get _filteredItems {
    final keyword = _searchController.text.trim().toLowerCase();

    return _items.where((item) {
      final name = (item['name'] ?? '').toLowerCase();
      final location = (item['location'] ?? '').toLowerCase();
      final status = item['status'] ?? '';

      final matchesSearch = keyword.isEmpty ||
          name.contains(keyword) ||
          location.contains(keyword);

      final matchesFilter =
          _selectedFilter == 'Semua' ||
          status == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // PESAN
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // BUILD HALAMAN
  @override
  Widget build(BuildContext context) {
    final results = _filteredItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pencarian',
          style: TextStyle(
            color: darkBlue,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SEARCH BAR
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Cari barang...',
                          hintStyle: const TextStyle(
                            color: textBlue,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: primaryBlue,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: _searchController.clear,
                                  icon: const Icon(
                                    Icons.close,
                                    color: textBlue,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // FILTER
                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _filterButton('Semua'),
                          const SizedBox(width: 10),
                          _filterButton('Hilang'),
                          const SizedBox(width: 10),
                          _filterButton('Ditemukan'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // JUDUL HASIL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hasil Pencarian',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        Text(
                          '${results.length} barang',
                          style: const TextStyle(
                            fontSize: 13,
                            color: textBlue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // HASIL PENCARIAN
                    if (results.isEmpty)
                      _emptyResult()
                    else
                      ...results.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _itemCard(item),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  // TOMBOL FILTER
  Widget _filterButton(String title) {
    final isSelected = _selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryBlue
                : const Color(0xFFD8E5F3),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : textBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // KARTU BARANG
  Widget _itemCard(Map<String, String> item) {
    final isLost = item['status'] == 'Hilang';
    final imagePath = item['image'] ?? '';

    return GestureDetector(
      onTap: () => _showItemDetail(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE1EAF4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // GAMBAR BARANG
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 78,
                height: 78,
                child: imagePath.isNotEmpty
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagePlaceholder();
                        },
                      )
                    : _imagePlaceholder(),
              ),
            ),

            const SizedBox(width: 13),

            // INFORMASI BARANG
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'Barang',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: textBlue,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['location'] ?? 'Lokasi tidak tersedia',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      color: textBlue,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isLost
                          ? const Color(0xFFFFF3E8)
                          : const Color(0xFFE8F7EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['status'] ?? 'Tidak diketahui',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isLost
                            ? const Color(0xFFE68A2E)
                            : const Color(0xFF36A269),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: textBlue,
            ),
          ],
        ),
      ),
    );
  }

  // GAMBAR PENGGANTI JIKA FILE TIDAK DITEMUKAN
  Widget _imagePlaceholder() {
    return Container(
      color: lightBlue,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 30,
        color: primaryBlue,
      ),
    );
  }

  // HASIL KOSONG
  Widget _emptyResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              color: lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 36,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Barang tidak ditemukan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Coba gunakan kata kunci lain\n'
            'atau ubah filter pencarian.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: textBlue,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // DETAIL BARANG
  void _showItemDetail(Map<String, String> item) {
    final imagePath = item['image'] ?? '';
    final isLost = item['status'] == 'Hilang';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // GARIS ATAS
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E5F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 25),

                // GAMBAR DETAIL BARANG
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: imagePath.isNotEmpty
                        ? Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _imagePlaceholder();
                            },
                          )
                        : _imagePlaceholder(),
                  ),
                ),

                const SizedBox(height: 12),

                // NAMA BARANG
                Text(
                  item['name'] ?? 'Barang',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 8),

                // STATUS
                Text(
                  item['status'] ?? 'Tidak diketahui',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isLost
                        ? const Color(0xFFE68A2E)
                        : const Color(0xFF36A269),
                  ),
                ),

                const SizedBox(height: 18),

                // LOKASI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: textBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        item['location'] ?? 'Lokasi tidak tersedia',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: textBlue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // WAKTU
                Text(
                  item['time'] ?? '',
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 25),

                // TOMBOL DETAIL
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _showMessage(
                        'Detail barang akan dikembangkan selanjutnya.',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // BOTTOM NAVIGATION
  Widget _bottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5ECF4),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // BERANDA
              _navItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Beranda',
                selected: false,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),

              // PENCARIAN
              _navItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Pencarian',
                selected: true,
                onTap: () {},
              ),

              // TAMBAH
              _navItem(
                icon: Icons.add_circle_outline_rounded,
                activeIcon: Icons.add_circle_rounded,
                label: 'Tambah',
                selected: false,
                onTap: () {
                  Navigator.pushNamed(context, '/add-report');
                },
              ),

              // NOTIFIKASI
              _navItem(
                icon: Icons.notifications_none_rounded,
                activeIcon: Icons.notifications_rounded,
                label: 'Notifikasi',
                selected: false,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/notification',
                  );
                },
              ),

              // PROFIL
              _navItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profil',
                selected: false,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ITEM NAVIGASI
  Widget _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? activeIcon : icon,
              size: 24,
              color: selected ? primaryBlue : textBlue,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? primaryBlue : textBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
