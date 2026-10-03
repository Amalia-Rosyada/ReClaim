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

  final List<Map<String, String>> _items = [
    {
      'name': 'Tas Hitam',
      'location': 'Gedung FKIP',
      'time': '2 jam yang lalu',
      'status': 'Hilang',
      'icon': '🎒',
    },
    {
      'name': 'Kunci Motor',
      'location': 'Area Kampus',
      'time': '5 jam yang lalu',
      'status': 'Ditemukan',
      'icon': '🔑',
    },
    {
      'name': 'Dompet Cokelat',
      'location': 'Perpustakaan',
      'time': 'Kemarin',
      'status': 'Hilang',
      'icon': '👛',
    },
    {
      'name': 'Botol Minum',
      'location': 'Laboratorium PTI',
      'time': 'Kemarin',
      'status': 'Ditemukan',
      'icon': '🧴',
    },
    {
      'name': 'Flashdisk',
      'location': 'Gedung G',
      'time': '2 hari yang lalu',
      'status': 'Hilang',
      'icon': '💾',
    },
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTER DATA
  // ============================================================

  List<Map<String, String>> get _filteredItems {
    final keyword =
        _searchController.text.trim().toLowerCase();

    return _items.where((item) {
      final name =
          item['name']!.toLowerCase();

      final location =
          item['location']!.toLowerCase();

      final status =
          item['status']!;

      final matchesSearch =
          keyword.isEmpty ||
          name.contains(keyword) ||
          location.contains(keyword);

      final matchesFilter =
          _selectedFilter == 'Semua' ||
          status == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final results = _filteredItems;

    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkBlue,
            size: 21,
          ),
        ),

        title: const Text(
          'Pencarian',
          style: TextStyle(
            color: darkBlue,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  8,
                  24,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // ==================================================
                    // SEARCH BAR
                    // ==================================================

                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius:
                            BorderRadius.circular(17),
                      ),
                      child: TextField(
                        controller:
                            _searchController,
                        textInputAction:
                            TextInputAction.search,
                        decoration:
                            InputDecoration(
                          hintText:
                              'Cari barang...',
                          hintStyle:
                              const TextStyle(
                            color: textBlue,
                            fontSize: 15,
                          ),

                          prefixIcon:
                              const Icon(
                            Icons.search,
                            color: primaryBlue,
                          ),

                          suffixIcon:
                              _searchController
                                      .text
                                      .isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController
                                            .clear();
                                      },
                                      icon:
                                          const Icon(
                                        Icons.close,
                                        color:
                                            textBlue,
                                      ),
                                    )
                                  : null,

                          border:
                              InputBorder.none,

                          contentPadding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // FILTER
                    // ==================================================

                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,
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

                    // ==================================================
                    // JUDUL HASIL
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'Hasil Pencarian',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight:
                                FontWeight.bold,
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

                    // ==================================================
                    // HASIL
                    // ==================================================

                    if (results.isEmpty)
                      _emptyResult()
                    else
                      ...results.map(
                        (item) => Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          child:
                              _itemCard(item),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar:
          _bottomNavigationBar(),
    );
  }

  // ============================================================
  // FILTER BUTTON
  // ============================================================

  Widget _filterButton(String title) {
    final isSelected =
        _selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryBlue
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryBlue
                : const Color(
                    0xFFD8E5F3,
                  ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : textBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ITEM CARD
  // ============================================================

  Widget _itemCard(
    Map<String, String> item,
  ) {
    final isLost =
        item['status'] == 'Hilang';

    return GestureDetector(
      onTap: () {
        _showItemDetail(item);
      },
      child: Container(
        padding:
            const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: const Color(
              0xFFE1EAF4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.03),
              blurRadius: 8,
              offset:
                  const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [

            // ==================================================
            // ICON BARANG
            // ==================================================

            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius:
                    BorderRadius.circular(15),
              ),
              alignment:
                  Alignment.center,
              child: Text(
                item['icon']!,
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ==================================================
            // INFORMASI BARANG
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    item['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),

                  const SizedBox(height: 5),

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
                          item['location']!,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 13,
                            color: textBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    item['time']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textBlue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ==================================================
            // STATUS
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isLost
                    ? const Color(
                        0xFFFFF3E8,
                      )
                    : const Color(
                        0xFFE8F7EE,
                      ),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Text(
                item['status']!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                  color: isLost
                      ? const Color(
                          0xFFE68A2E,
                        )
                      : const Color(
                          0xFF36A269,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HASIL KOSONG
  // ============================================================

  Widget _emptyResult() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
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
            'Coba gunakan kata kunci lain\natau ubah filter pencarian.',
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

  // ============================================================
  // DETAIL SEMENTARA
  // ============================================================

  void _showItemDetail(
    Map<String, String> item,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            30,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [

              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFD8E5F3,
                  ),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                item['icon']!,
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                item['name']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                item['status']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      item['status'] == 'Hilang'
                          ? const Color(
                              0xFFE68A2E,
                            )
                          : const Color(
                              0xFF36A269,
                            ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: textBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item['location']!,
                    style: const TextStyle(
                      color: textBlue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Text(
                item['time']!,
                style: const TextStyle(
                  color: textBlue,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    _showMessage(
                      'Detail barang akan dikembangkan selanjutnya.',
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        primaryBlue,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

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
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [

              _navItem(
                icon: Icons.home_outlined,
                label: 'Beranda',
                selected: false,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/home',
                  );
                },
              ),

              _navItem(
                icon: Icons.search,
                label: 'Pencarian',
                selected: true,
                onTap: () {},
              ),

              _navItem(
                icon: Icons.add_circle_outline,
                label: 'Tambah',
                selected: false,
                onTap: () {
                  _showMessage(
                    'Halaman tambah laporan akan dibuat selanjutnya.',
                  );
                },
              ),

              _navItem(
                icon:
                    Icons.notifications_none,
                label: 'Notifikasi',
                selected: false,
                onTap: () {
                  _showMessage(
                    'Halaman notifikasi akan dibuat selanjutnya.',
                  );
                },
              ),

              _navItem(
                icon: Icons.person_outline,
                label: 'Profil',
                selected: false,
                onTap: () {
                  _showMessage(
                    'Halaman profil akan dibuat selanjutnya.',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NAV ITEM
  // ============================================================

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior:
          HitTestBehavior.opaque,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected
                  ? primaryBlue
                  : textBlue,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: selected
                    ? primaryBlue
                    : textBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}