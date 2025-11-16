 APLIKASI KASIR WARUNG FLUTTER
======================================

Terima kasih telah menggunakan aplikasi ini. Dokumen ini akan membantu Anda memahami cara penggunaan dan kustomisasi dasar.


---
### Cara Penggunaan Aplikasi
---

Aplikasi ini memiliki 5 menu utama di bagian bawah layar:

1.  **Home:**
    * **Dashboard Penjualan:** Menampilkan ringkasan penjualan harian, mingguan, dan bulanan (data diambil dari riwayat transaksi).
    * **Pencarian Produk:** Anda bisa mencari produk berdasarkan nama dari semua kategori.
    * **Daftar Utang:** Menampilkan semua catatan utang. Anda bisa menambah, mengedit, atau menghapus data utang melalui halaman ini. Tombol `+` di pojok kanan bawah adalah untuk menambahkan utang baru.

2.  **Menu:**
    * Halaman ini menampilkan semua kategori menu Anda.
    * **Menambah Kategori:** Tekan tombol `+` di pojok kanan bawah untuk menambahkan kategori baru.
    * **Melihat Produk:** Tekan pada salah satu kotak kategori untuk masuk dan melihat daftar produk di dalamnya.
    * **CRUD Produk:** Di dalam halaman produk, Anda bisa menambah, mengedit, dan menghapus produk.

3.  **Keranjang:**
    * Menampilkan semua produk yang telah Anda tambahkan ke keranjang.
    * **Mengatur Jumlah:** Gunakan tombol `+` dan `-` untuk mengubah jumlah setiap produk.
    * **Checkout:** Tekan tombol "Checkout". Anda akan diminta memasukkan nama pelanggan (opsional), lalu transaksi akan disimpan.

4.  **Riwayat:**
    * Menampilkan semua riwayat transaksi yang telah berhasil di-checkout, diurutkan dari yang terbaru.
    * **Melihat Struk:** Tekan pada salah satu riwayat untuk melihat detail struk.
    * **Fitur di Halaman Struk:**
        * **Hapus:** Tombol ikon sampah untuk menghapus riwayat transaksi secara permanen.
        * **Bagikan:** Tombol ikon share untuk membagikan detail struk sebagai teks ke aplikasi lain (WhatsApp, Bluetooth, dll.).
        * **Cetak:** Tombol ikon print untuk mencetak struk ke dalam format PDF.

5.  **Utang:**
    * Halaman khusus untuk melihat dan mengelola daftar orang yang berutang (fitur CRUD lengkap).


---
### Cara Kustomisasi Sederhana
---

Anda bisa dengan mudah mengubah tampilan dasar aplikasi.

1.  **Mengubah Warna Utama Aplikasi:**
    * Buka file `lib/main.dart`.
    * Cari baris `primarySwatch: Colors.blue,`.
    * Ganti `Colors.blue` dengan warna lain yang Anda inginkan, misalnya `Colors.green`, `Colors.orange`, atau `Colors.teal`.

2.  **Mengubah Tampilan AppBar (Bilah Atas):**
    * Masih di file `lib/main.dart`, cari bagian `appBarTheme`.
    * Anda bisa mengubah `backgroundColor` (warna latar), `foregroundColor` (warna teks dan ikon), dan `elevation` (efek bayangan).

    Contoh:
    ```dart
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.brown,  // Latar menjadi coklat
      foregroundColor: Colors.white, // Teks menjadi putih
      elevation: 0,                   // Menghilangkan bayangan
    ),
    ```

3.  **Mengubah Ikon Navigasi:**
    * Buka file `lib/presentation/pages/main_page.dart`.
    * Cari bagian `items: const <BottomNavigationBarItem>[ ... ]`.
    * Ganti `Icon(Icons.home)` dengan ikon lain yang Anda inginkan, misalnya `Icon(Icons.store)`.
