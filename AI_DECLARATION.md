# AI DECLARATION

## 1. Tujuan Deklarasi

Berkas ini dibuat sebagai bentuk transparansi penggunaan kecerdasan buatan (*Artificial Intelligence* atau AI) selama pengembangan aplikasi ReClaim, yaitu aplikasi berbasis Flutter untuk pelaporan barang hilang dan ditemukan. AI digunakan sebagai alat bantu dalam memahami kode, mencari solusi terhadap kendala pemrograman, dan menyempurnakan fitur aplikasi. Setiap saran yang digunakan tetap disesuaikan dengan kebutuhan proyek dan diperiksa oleh pengembang.

## 2. Daftar Alat AI

Alat AI yang digunakan selama pengembangan ReClaim adalah:

- **ChatGPT:** Membantu memahami kode Flutter dan Dart, mencari solusi kesalahan program, menyusun logika fitur, serta memberikan saran perbaikan antarmuka dan pengelolaan data.

## 3. Pembagian Peran AI dan Pengembang

Pembagian peran dalam pengembangan aplikasi ReClaim dijelaskan sebagai berikut.

- **Antarmuka aplikasi**
  - Peran AI: Memberikan saran mengenai struktur tampilan dan perbaikan komponen antarmuka.
  - Peran pengembang: Menentukan desain yang digunakan dan menyesuaikannya dengan kebutuhan aplikasi.

- **Navigasi halaman**
  - Peran AI: Membantu memahami alur navigasi dan menganalisis kemungkinan kesalahan perpindahan halaman.
  - Peran pengembang: Memeriksa rute dan memastikan navigasi sesuai dengan alur aplikasi.

- **Penambahan laporan**
  - Peran AI: Membantu memahami logika pengisian, validasi, dan penyimpanan data laporan.
  - Peran pengembang: Menyesuaikan struktur data dan memeriksa proses penyimpanan laporan.

- **Pengelolaan foto**
  - Peran AI: Membantu menjelaskan proses pemilihan, penyimpanan, dan penampilan foto.
  - Peran pengembang: Menyesuaikan implementasi penyimpanan foto dalam format *Base64* serta proses penampilannya kembali.

- **Beranda dan riwayat laporan**
  - Peran AI: Membantu menganalisis pembacaan, pengurutan, dan penghapusan data laporan.
  - Peran pengembang: Memeriksa kesesuaian tampilan data dan memastikan proses penghapusan bekerja sesuai kebutuhan.

- **Pengujian dan perbaikan kode**
  - Peran AI: Memberikan saran skenario pengujian dan kemungkinan penyebab kesalahan.
  - Peran pengembang: Menjalankan aplikasi, memeriksa hasil pengujian, dan menentukan perbaikan yang diperlukan.

Pembagian tersebut menjelaskan peran AI sebagai alat bantu, sedangkan pengembang tetap bertanggung jawab atas penyesuaian kode, keputusan implementasi, dan pemeriksaan hasil akhir.

## 4. Studi Kasus *Prompting*

### 4.1 Penyimpanan Data Laporan dan Foto

**Prompt:**

> Bantu periksa dan perbaiki kode Flutter untuk menyimpan data laporan barang hilang atau ditemukan menggunakan SharedPreferences. Data laporan mencakup jenis laporan, nama barang, lokasi, deskripsi, tanggal, status, dan foto. Pertahankan kode penting yang sudah ada dan jelaskan bagian yang perlu disesuaikan agar data dapat ditampilkan kembali.

**Hasil awal dari AI:**

AI memberikan saran mengenai struktur data laporan, penggunaan `SharedPreferences` untuk penyimpanan lokal, serta konversi data menggunakan JSON agar laporan dapat disimpan dan dibaca kembali.

**Penyesuaian manual oleh pengembang:**

Implementasi disesuaikan dengan struktur laporan ReClaim. Data laporan disimpan dalam daftar `user_reports`, sedangkan setiap laporan dikonversi menjadi JSON menggunakan `jsonEncode()`. Foto dibaca sebagai `Uint8List` dan dikonversi menggunakan `base64Encode()` agar dapat disimpan bersama informasi laporan.

### 4.2 Penampilan dan Penghapusan Riwayat Laporan

**Prompt:**

> Bantu periksa kode Flutter pada halaman beranda dan riwayat laporan agar data yang tersimpan di SharedPreferences dapat ditampilkan kembali. Pastikan foto yang disimpan dalam bentuk Base64 dapat ditampilkan, laporan diurutkan sesuai kebutuhan halaman, dan penghapusan laporan memperbarui data yang tersimpan. Jangan menghapus fungsi penting yang sudah ada.

**Hasil awal dari AI:**

AI memberikan saran mengenai pembacaan data laporan, konversi JSON menjadi objek data, penampilan foto menggunakan `Image.memory()`, dan pembaruan penyimpanan setelah laporan dihapus.

**Penyesuaian manual oleh pengembang:**

Kode disesuaikan dengan implementasi ReClaim. Halaman beranda mengurutkan laporan berdasarkan tanggal terbaru, sedangkan halaman riwayat membalik urutan data yang tersimpan. Foto ditampilkan melalui `base64Decode()` dan `Image.memory()`. Penghapusan laporan dilengkapi konfirmasi sebelum data pada penyimpanan lokal diperbarui.

## 5. Tanggung Jawab Pengembang

Seluruh saran AI digunakan sebagai bahan bantuan yang perlu diperiksa dan disesuaikan, bukan langsung diterapkan tanpa evaluasi. Pengembang bertanggung jawab memahami logika program, menyesuaikan kode dengan struktur proyek, dan menguji fitur yang dikembangkan.

Deklarasi ini dibuat untuk menjelaskan penggunaan AI secara terbuka selama pengembangan ReClaim serta menunjukkan keterlibatan pengembang dalam proses implementasi, penyesuaian, dan evaluasi kode program.