# Makassar Restaurant App

Aplikasi mobile berbasis Flutter untuk menemukan restoran terbaik di Makassar. Aplikasi ini menggunakan **Clean Architecture** dan berinteraksi dengan REST API backend untuk memberikan rekomendasi restoran berdasarkan lokasi pengguna (GPS), rating, dan filter radius.

## 🌟 Fitur Utama

- **📍 Rekomendasi Berbasis Lokasi**: Menampilkan restoran terdekat dari posisi pengguna secara real-time.
- **🎯 Radius Filter**: Pengguna dapat mengatur radius pencarian (1km, 5km, 10km) untuk memperluas atau mempersempit jangkauan.
- **📜 Infinite Scroll (Lazy Loading)**: Paginasi data otomatis saat pengguna scroll ke bawah untuk efisiensi memori dan bandwidth.
- **🔍 Pencarian Cerdas**: Mencari restoran berdasarkan nama atau menu.
- **🗺️ Integrasi Peta**: Navigasi ke lokasi restoran.
- **📱 Responsive UI**: Tampilan modern yang menyesuaikan dengan berbagai ukuran layar.

## 🧠 Penjelasan Teknis & Algoritma

### 1. Sistem Rekomendasi Lokasi (Geospatial)
Aplikasi ini menggunakan algoritma **Haversine Formula** (diimplementasikan di sisi backend) untuk menghitung jarak tegak lurus antara koordinat pengguna (Latitude/Longitude) dengan koordinat restoran di database.

**Alur Kerja:**
1.  **Frontend** meminta izin lokasi dan mengambil koordinat pengguna saat ini menggunakan package `geolocator`.
2.  Koordinat dikirim ke API endpoint `/recommendations` beserta parameter `radius` dan `limit`.
3.  **Backend** memfilter restoran yang masuk dalam radius yang dipilih dan mengurutkannya berdasarkan jarak terdekat.

### 2. Pagination & Lazy Loading
Untuk menangani database restoran yang besar, aplikasi tidak memuat semua data sekaligus.
- Menggunakan parameter `limit` (default: 10) dan `offset` (kursor data).
- Saat pengguna scroll mencapai 80% dari bawah list, `ScrollController` akan memicu provider untuk mengambil "halaman" data berikutnya.
- State `isLoading` dan `hasMore` dijaga untuk mencegah request duplikat dan memberitahu user jika data sudah habis.

### 3. State Management (Provider)
Menggunakan pola **Provider** untuk memisahkan business logic dari UI.
- **RestaurantProvider**: Menghandle state list restoran, status loading, error handling, dan logika filter radius.
- Perubahan pada radius akan mereset list dan memicu fetch ulang secara otomatis.

## 🛠️ Tech Stack

- **Frontend**: Flutter SDK 3.x
- **Language**: Dart
- **Architecture**: Clean Architecture (Presentation, Domain, Data)
- **State Management**: Provider
- **Networking**: Http client
- **Location**: Geolocator

## 📂 Struktur Folder

Struktur folder mengikuti prinsip Clean Architecture untuk maintainability dan scalability.

```
lib/
├── core/                   # Konfigurasi dasar, tema, konstanta
│   ├── config.dart         # Base URL API & Environment config
│   └── app_colors.dart     # Design tokens
├── data/                   # Layer Data: Sumber data & Repository impl
│   ├── datasources/        # Remote/Local data fetcher
│   ├── models/             # DTO (Data Transfer Objects) & Serialisasi JSON
│   └── repositories/       # Implementasi repository
├── domain/                 # Layer Bisnis: Entity & Use Cases (Murni Dart)
│   ├── entities/           # Objek bisnis core
│   ├── usecases/           # Logika bisnis spesifik
│   └── repositories/       # Interface repository (Contract)
├── presentation/           # Layer UI
│   ├── providers/          # State Management logic
│   ├── views/              # Halaman-halaman aplikasi (Screens)
│   └── widgets/            # Komponen UI yang reusable
└── utils/                  # Fungsi bantuan umum
```

## 🚀 Instalasi & Cara Menjalankan

### Prasyarat
- Flutter SDK terinstall.
- Backend API sudah berjalan (Localhost atau Network).

### 1. Konfigurasi Endpoint (PENTING)
Agar aplikasi bisa berjalan di Device Fisik (HP) atau Emulator, Anda perlu mengkonfigurasi IP Address backend.

Buka file `lib/core/config.dart`:

```dart
class Config {
  // GANTI dengan IP Address Laptop/PC Anda
  // Cara cek IP: 
  // - Windows: buka cmd ketik `ipconfig` -> IPv4 Address
  // - Mac/Linux: buka terminal ketik `ifconfig` -> inet
  
  static const String baseUrl = 'http://192.168.1.XX:8000'; 
}
```

> **Catatan:** Pastikan HP/Device dan Laptop berada dalam jaringan WiFi yang sama.

### 2. Install Dependencies
Jalankan perintah ini di terminal project:

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

**Untuk Emulator:**
```bash
flutter run
```

**Untuk Device Fisik (Via USB/WiFi):**
Pastikan USB Debugging aktif, lalu:
```bash
flutter run -d <device_id>
```

## 🔐 Permissions
Aplikasi ini membutuhkan akses lokasi.
- **Android**: `ACCESS_FINE_LOCATION` (sudah dikonfigurasi di AndroidManifest)
- **iOS**: `NSLocationWhenInUseUsageDescription` (sudah dikonfigurasi di Info.plist)

---
*Dibuat oleh Tim Developer Makassar Restaurant*
