# ☕ Coffee Recipe
**Coffee Recipe** adalah aplikasi Flutter yang menggunakan layanan AI untuk menghasilkan resep kopi berdasarkan nama kopi yang dimasukkan pengguna. Aplikasi ini juga menyimpan resep dalam database Hive agar bisa diakses kembali.

## 📌 Fitur Utama

### 🔹 Input Nama Kopi
Pengguna dapat memasukkan nama kopi yang ingin dibuat.

### 🔹 Generate Resep dengan AI
Setelah memasukkan nama kopi, aplikasi akan menggunakan layanan AI (**Gemini Services**) untuk menghasilkan:
- **Daftar bahan**
- **Langkah-langkah pembuatan**

### 🔹 Penyimpanan Resep (Hive Database)
Resep yang dihasilkan akan disimpan dalam **Hive database**, sehingga pengguna bisa melihat kembali resep-resep yang sudah dibuat sebelumnya.

### 🔹 Riwayat Resep (History Page)
Pengguna dapat mengakses halaman riwayat untuk melihat kembali resep-resep kopi yang telah dibuat.

### 🔹 Tampilan Dinamis & Interaktif
- **Shimmer Effect** saat proses loading untuk pengalaman pengguna yang lebih baik.
- **Desain modern** dengan elemen UI yang nyaman dan estetis.

### 🔹 Navigasi dengan Bottom Navigation Bar
Navigasi mudah untuk berpindah antara halaman **rekomendasi** dan **pembuatan resep kopi**.

---

## 🚀 Cara Kerja Aplikasi
1. Pengguna memasukkan nama kopi.
2. Sistem menghapus input sebelumnya dan menyimpan kopi yang baru dimasukkan.
3. AI menghasilkan resep berdasarkan nama kopi yang dimasukkan.
4. Resep (bahan & langkah-langkah) ditampilkan di layar dan disimpan di database.
5. Pengguna dapat mengakses **riwayat resep** kapan saja melalui **History Page**.

---

## 📲 Instalasi dan Menjalankan Aplikasi
### 🔧 Prasyarat
Pastikan sudah menginstal:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Hive](https://pub.dev/packages/hive)
- [Google Fonts](https://pub.dev/packages/google_fonts)

### 🔄 Clone Repository
```sh
git clone https://github.com/username/coffee-recipe.git
cd coffee-recipe
```

### ▶️ Jalankan Aplikasi
```sh
flutter pub get
flutter run
```

---

## 📦 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  hive_flutter: ^1.1.0
  google_fonts: ^4.0.4
  shimmer: ^3.0.0
```

---

## 🎨 Tampilan Aplikasi

![Mocups](https://via.placeholder.com/150)


## ✨ Kontribusi
Jika ingin berkontribusi, silakan lakukan **fork** repository ini dan buat **pull request** dengan perubahan yang ingin diajukan.

---

## 📜 Lisensi
Aplikasi ini dirilis dengan lisensi **MIT License**.

📌 Dibuat dengan ❤️ oleh **[Nama Kamu]**


