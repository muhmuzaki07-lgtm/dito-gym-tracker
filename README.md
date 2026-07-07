# Dito Gym Tracker

Aplikasi tracking latihan hipertrofi (Upper-Lower Split, Men's Physique) —
Flutter, Material 3, dark mode premium dengan accent gold.

## Fitur yang sudah diimplementasikan

- **Home**: sapaan, workout hari ini, progress minggu ini, streak, berat badan terakhir, tombol Start Workout
- **Workout**: program mingguan lengkap (Senin–Minggu sesuai spesifikasi), rest day checklist
- **Sesi Latihan**: input berat & reps per set, checkbox selesai, catatan, link video YouTube, rest timer (60/90/120/180s + getar)
- **Progressive Overload**: otomatis membandingkan sesi sebelumnya dan merekomendasikan kenaikan beban 2.5–5% jika semua set mencapai batas atas rep range
- **Progress**: grafik berat badan & volume latihan (fl_chart), total latihan/set/volume, streak, riwayat sesi
- **Nutrition**: input profil (berat/tinggi/umur/gender/aktivitas), kalkulasi otomatis BMR (Mifflin-St Jeor), TDEE, target kalori/protein/karbo/lemak, tracker air minum
- **Settings**: toggle kg/lbs, reminder latihan & minum air (local notification), export CSV, export PDF, backup JSON
- **Local storage**: semua data tersimpan di Hive (offline penuh, tidak butuh internet)

Semua logic (kalkulasi, progressive overload, program latihan, model data)
sudah lengkap dan siap pakai. TypeAdapter Hive ditulis manual (bukan lewat
`build_runner`) supaya proyek langsung compile tanpa langkah codegen tambahan.

## Cara build APK

Proyek ini berisi seluruh kode `lib/` dan `pubspec.yaml`, tapi **belum**
memiliki folder platform (`android/`, `ios/`) karena itu di-generate oleh
Flutter SDK itu sendiri dan bukan kode yang perlu ditulis manual. Langkah:

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel) jika belum ada.
2. Ekstrak project ini, lalu di dalam foldernya jalankan:
   ```bash
   flutter create . --project-name dito_gym_tracker --platforms android,ios
   ```
   Ini akan menghasilkan folder `android/` dan `ios/` standar TANPA menimpa
   `lib/` atau `pubspec.yaml` yang sudah ada (Flutter hanya mengisi folder
   platform yang belum ada).
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Jalankan di emulator/device untuk testing:
   ```bash
   flutter run
   ```
5. Build APK release:
   ```bash
   flutter build apk --release
   ```
   Output ada di `build/app/outputs/flutter-apk/app-release.apk`.

### Permission tambahan (Android)

Setelah `flutter create` men-generate `android/app/src/main/AndroidManifest.xml`,
tambahkan permission berikut di dalam tag `<manifest>` (di atas `<application>`)
untuk notifikasi & getar:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### Jika ingin generate ulang Hive adapter via build_runner (opsional)

Adapter di `lib/data/models/workout_models.dart` sudah ditulis manual dan
berfungsi penuh, jadi ini **tidak wajib**. Tapi jika ke depannya menambah
field baru dan ingin pakai `@HiveType`/`@HiveField` + codegen, tinggal
tambahkan `hive_generator` + `build_runner` ke `dev_dependencies` dan jalankan
`flutter pub run build_runner build`.

## Struktur Folder

```
lib/
  core/
    constants/app_colors.dart      # palet warna
    theme/app_theme.dart           # tema Material 3 dark + gold
    utils/calculations.dart        # BMR/TDEE + progressive overload
    services/notification_service.dart
  data/
    models/workout_models.dart     # Hive models + adapters
    datasources/program_data.dart  # program latihan mingguan (statis)
    repositories/workout_repository.dart
  presentation/
    providers/                    # Riverpod state
    screens/
      home/  workout/  progress/  nutrition/  settings/
    widgets/                      # bottom nav, rest timer sheet, set row
  main.dart
```

## Catatan

- Video tutorial exercise membuka pencarian YouTube (bukan embed player) —
  cukup ketuk ikon play di setiap exercise saat sesi latihan berlangsung.
- Foto/animasi gerakan: slot `imageAsset` sudah tersedia di
  `ExercisePrescription` (program_data.dart) untuk kamu isi sendiri; folder
  `assets/images/` sudah disiapkan.
- Ganti nama pengguna default ("Dito") lewat data `AppSettings` — bisa
  ditambahkan field edit di Settings jika mau, strukturnya sudah siap.
