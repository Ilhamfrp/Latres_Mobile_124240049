# Latres Mobile — Skuy Nonton!

Aplikasi nonton series/show TV dengan data dari **TVMaze API** (Latihan Responsi Praktikum Mobile SI-B).
Kode ditulis mengikuti gaya **Modul 5 (HTTP Request), Modul 6 (Local Storage), dan Modul 8 (GetX)**,
jadi bisa dipakai sambil belajar. Bagian **Notification & LBS (Modul 7)** tidak dipakai di aplikasi,
tapi kodenya ada di bagian bawah README ini untuk dipelajari.

> ⚠️ Kode belum pernah dijalankan/di-compile oleh pembuatnya (tidak ada Flutter SDK saat dibuat).
> Kalau ada error saat `flutter run`, kirim pesan error-nya supaya bisa diperbaiki.

---

## 1. Cara menjalankan (Windows)

1. Buat project baru: `flutter create latres_mobile`
2. Salin `pubspec.yaml` dan seluruh folder `lib/` dari project ini, timpa milik project baru.
3. Buka `lib/utils/constants.dart`, pastikan `kNim` berisi **NIM kamu** (username login = NIM, password = `123`).
4. Jalankan:
   ```bash
   flutter pub get
   flutter run
   ```
5. Pakai emulator/HP yang terhubung internet. Untuk build release, pastikan `android/app/src/main/AndroidManifest.xml`
   punya `<uses-permission android:name="android.permission.INTERNET"/>`.

Pengumpulan: push ke repo GitHub bernama `Latres_Mobile_[NIM]`, kumpulkan link repo-nya.

---

## 2. Struktur folder

Mengikuti struktur Modul 8 (model → service → controller → view).

```
lib/
├── main.dart                     # init Hive + GetMaterialApp
├── model/
│   ├── show.dart                 # model data API (factory fromJson)
│   ├── favorite_show.dart        # model yang disimpan di Hive
│   └── favorite_show.g.dart      # adapter Hive
├── service/
│   └── show_service.dart         # fetch & parse API (terpisah dari UI)
├── controller/
│   ├── show_controller.dart      # state Home (list, loading, error)
│   ├── detail_controller.dart    # state Detail
│   └── favorite_controller.dart  # operasi CRUD Hive
├── routes/
│   ├── app_routes.dart           # nama-nama route
│   └── app_pages.dart            # daftar halaman + Binding
├── view/
│   ├── pages/                    # login, main, home, detail, favorite, profile
│   └── widgets/show_card.dart    # card show (reusable)
└── utils/constants.dart          # NIM, key SharedPreferences, warna
```

---

## 3. Pemetaan kriteria soal → modul → file

| Kriteria soal | Konsep (modul) | File |
|---|---|---|
| Login, username = NIM, password 123 | `TextEditingController`, `_login()` (Modul 6) | `view/pages/login_page.dart` |
| Simpan session | `SharedPreferences.setBool('loginData', true)` (Modul 6) | `login_page.dart` |
| Cek sudah login | `_checkLogin()` di `initState()` (Modul 6) | `login_page.dart` |
| Logout hapus session | `prefs.remove(...)` + `Get.offAllNamed` (Modul 6 & 8) | `view/pages/profile_page.dart` |
| BottomNavigationBar | `setState` + `IndexedStack` (Modul 3) | `view/pages/main_page.dart` |
| Fetch API `/shows` | `http.get`, `jsonDecode`, `async/await` (Modul 5) | `service/show_service.dart` |
| Fetch & parse dipisah dari UI | Service class (Modul 8 bagian C) | `service/show_service.dart` |
| Model data | `factory Product.fromJson()` (Modul 5 bagian G) | `model/show.dart` |
| Loading indicator | `CircularProgressIndicator` + `isLoading` | `home_page.dart`, `detail_page.dart` |
| Grid: gambar, judul, rating | `GridView.builder` + `ShowCard` (Modul 8) | `home_page.dart`, `widgets/show_card.dart` |
| Klik → detail | `Get.toNamed(..., arguments: id)` (Modul 8) | `home_page.dart` |
| Detail dari `/shows/{id}` | kirim **id**, fetch lagi di detail (Modul 5 bagian D) | `detail_controller.dart` |
| Tombol favorit | Hive `add()` / `deleteAt()` (Modul 6) | `favorite_controller.dart` |
| Halaman favorit, bisa dihapus | `ValueListenableBuilder` + `getAt()` + `deleteAt()` (Modul 6) | `view/pages/favorite_page.dart` |
| Profil: username dari SharedPreferences | `prefs.getString(...)` | `profile_page.dart` |
| Bonus GetX | `.obs`, `Obx`, `Get.lazyPut`, Binding, named routes (Modul 8) | `controller/`, `routes/` |

---

## 4. Alur data (Fetch → Parse → Render)

Sesuai Modul 5, setiap halaman yang memakai API melewati tiga tahap:

1. **Fetch**: `ShowService.fetchShows()` memanggil `http.get(...)`.
2. **Parse**: `jsonDecode()` mengubah JSON menjadi `List`/`Map`, lalu `Show.fromJson()` mengubah tiap `Map` menjadi objek `Show`.
3. **Render**: `ShowController` menyimpan hasilnya di `RxList`, dan `Obx()` di `HomePage` menampilkannya.

Catatan tentang respons TVMaze:
- `/shows` langsung mengembalikan **List** (tidak dibungkus key seperti `data['products']` di dummyjson).
- Field `image` dan `rating.average` bisa **null**, jadi di `Show.fromJson()` dipakai `?.` dan `as num?`.
- URL gambar berawalan `http://`, diubah ke `https://` karena Android memblokir koneksi non-HTTPS.
- `summary` berisi tag HTML (`<p>`, `<b>`), dibersihkan dengan `RegExp` di getter `cleanSummary`.

### Konsep GetX yang dipakai

| Konsep | Contoh di project | Fungsi |
|---|---|---|
| Variabel reaktif | `final RxBool _isLoading = false.obs;` | Nilai yang "diawasi" |
| `Obx()` | `Obx(() { ... controller.isLoading ... })` | Rebuild otomatis bagian UI saat nilai berubah |
| Controller | `ShowController extends GetxController` | Tempat state + logika, UI hanya menampilkan |
| `onInit()` | memanggil `retrieveData()` | Setara `initState()` |
| Binding + `Get.lazyPut` | `MainBinding`, `DetailBinding` | Daftarkan controller sebelum halaman dibuka |
| `Get.find()` | `Get.find<ShowController>()` | Ambil controller yang sudah terdaftar |
| Named route + arguments | `Get.toNamed(AppRoutes.detail, arguments: show.id)` | Navigasi + kirim data; diterima via `Get.arguments` |
| `Get.offAllNamed` | login ↔ main | Setara `pushAndRemoveUntil` |
| `Get.back()` | tombol kembali di detail | Setara `Navigator.pop` |

### SharedPreferences vs Hive (Modul 6)

- **SharedPreferences**: key-value sederhana, dipakai untuk session login (`loginData`, `username`).
- **Hive**: database NoSQL lokal untuk data utama aplikasi, dipakai untuk daftar favorit. Perubahan pada Box
  otomatis memperbarui UI lewat `ValueListenableBuilder`.

---

## 5. Hive Adapter (`favorite_show.g.dart`)

Di Modul 6, file `todo.g.dart` dibuat otomatis oleh `build_runner`. Di project ini `favorite_show.g.dart`
sudah **ditulis manual** mengikuti hasil generate, supaya project langsung jalan tanpa langkah tambahan.

Kalau mau mencoba cara generate seperti di modul:

1. Tambahkan di `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     hive_generator: ^2.0.1
     build_runner: ^2.4.8
   ```
2. Hapus `lib/model/favorite_show.g.dart`.
3. Jalankan di terminal:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
4. File `favorite_show.g.dart` akan terbentuk lagi dengan nama adapter `FavoriteShowAdapter`.

Penting: `typeId: 0` adalah identifier class di Hive. Kalau punya class Hive lain, pakai angka berbeda.

---

## 6. Bahan belajar: Notification & LBS (Modul 7)

Fitur ini **tidak dipakai di aplikasi** (tidak ada di kriteria), tapi tetap dipelajari. Kode di bawah mengikuti
Modul 7 (aplikasi "Nearby Reminder"). Cara belajar paling enak: buat **project Flutter baru** khusus
percobaan, jalankan di HP fisik/emulator, baru nanti coba sambungkan ke aplikasi ini (lihat 6.8).

Ringkasnya:
- **Local Notification**: dipicu aplikasi di perangkat, tanpa internet. Ada *immediate* (muncul langsung)
  dan *scheduled* (muncul di waktu tertentu, tetap muncul walau app ditutup).
- **LBS (Location-Based Services)**: memakai lokasi pengguna. Alurnya: cek GPS aktif → minta permission →
  ambil koordinat (`Geolocator.getCurrentPosition`) → hitung jarak (`Geolocator.distanceBetween`).

### 6.1 Dependency (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^19.0.0
  timezone: ^0.10.0
  geolocator: ^13.0.0
```

### 6.2 Desugaring (`android/app/build.gradle.kts`)

Diperlukan agar scheduled notification jalan di Android versi lama.

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true // tambah
    }
}

// di luar blok android, di bawahnya
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

### 6.3 Permission & receiver (`android/app/src/main/AndroidManifest.xml`)

```xml
<!-- Di dalam <manifest>, di luar <application> -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Di dalam <application>, di bawah <activity> -->
<receiver
    android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver
    android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
    </intent-filter>
</receiver>
<receiver
    android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsReceiver"/>
```

`uses-permission` mengizinkan app menampilkan notifikasi dan membaca lokasi. `receiver` menerima alarm dari
sistem saat waktu notifikasi tiba; tanpa receiver, scheduled notification tidak akan pernah muncul.

### 6.4 `lib/services/notification_service.dart`

Memakai **Singleton Pattern**: hanya ada satu instance `NotificationService` di seluruh aplikasi.

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Inisialisasi timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // 2. Konfigurasi Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await notificationPlugin.initialize(initSettings);

    // 3. Request permission dan buat channel
    final androidPlatform = notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlatform?.requestNotificationsPermission();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminder Notifications',
      description: 'Channel untuk reminder notifikasi',
      importance: Importance.high,
    );
    await androidPlatform?.createNotificationChannel(channel);
  }

  // Immediate notification: muncul langsung saat dipanggil
  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notifDetails =
        NotificationDetails(android: androidDetails);

    await notificationPlugin.show(0, title, body, notifDetails);
  }

  // Scheduled notification: muncul di waktu yang ditentukan
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notifDetails =
        NotificationDetails(android: androidDetails);

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      // TZDateTime dibuat dari komponen waktu agar tidak salah konversi timezone
      tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
      ),
      notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
```

Tiga function utamanya:
- `init()`: konfigurasi awal, dipanggil di `main()`.
- `showInstantNotification()`: notifikasi langsung (`.show()`).
- `scheduleNotification()`: notifikasi terjadwal (`.zonedSchedule()`).

Semuanya `async` karena Flutter harus bicara ke Android lewat platform channel.

### 6.5 Panggil `init()` di `main.dart`

```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
```

### 6.6 `lib/data/locations.dart` (data dummy untuk LBS)

```dart
class LocationData {
  final String name;
  final double lat;
  final double lng;

  const LocationData({
    required this.name,
    required this.lat,
    required this.lng,
  });
}

const List<LocationData> dummyLocations = [
  LocationData(name: 'Kampus',
      lat: -7.782383704688537, lng: 110.41586606343337),
  LocationData(name: 'Minimarket',
      lat: -7.783139925317062, lng: 110.41454302410676),
  LocationData(name: 'Kantin',
      lat: -7.782466604443315, lng: 110.41618756029608),
  LocationData(name: 'Masjid',
      lat: -7.781581023250215, lng: 110.41502197824055),
  LocationData(name: 'Kos',
      lat: -7.780829957491809, lng: 110.41722718735446),
];
```

### 6.7 `lib/screens/home_screen.dart` (Nearby Reminder)

Gabungan tiga fitur: notifikasi langsung, cek lokasi terdekat, dan set reminder ke lokasi.
Lokasi yang jaraknya kurang dari 150 meter ditandai hijau.

```dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/locations.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State reminder
  DateTime? _scheduledTime;
  LocationData? _selectedLocation;

  // State LBS
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  List<Map<String, dynamic>> _locationsWithDistance = [];

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);

    String dateLabel;
    if (date == today) {
      dateLabel = 'Hari ini';
    } else if (date == tomorrow) {
      dateLabel = 'Besok';
    } else {
      dateLabel = '${dt.day}/${dt.month}/${dt.year}';
    }
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$dateLabel, $hour:$minute';
  }

  // Ubah meter menjadi teks yang mudah dibaca
  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;
    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      _scheduledTime = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute,
      );
    });
  }

  // Inti LBS: cek GPS -> permission -> ambil posisi -> hitung jarak -> urutkan
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationsWithDistance = [];
    });

    // 1. Cek apakah GPS aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('GPS tidak aktif.')));
      }
      setState(() => _isLoadingLocation = false);
      return;
    }

    // 2. Cek dan minta permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permission lokasi ditolak.')));
        }
        setState(() => _isLoadingLocation = false);
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission lokasi diblokir.')));
      }
      setState(() => _isLoadingLocation = false);
      return;
    }

    // 3. Ambil posisi
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // 4. Hitung jarak ke semua lokasi dummy
    final result = dummyLocations.map((loc) {
      final distance = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        loc.lat, loc.lng,
      );
      return {'location': loc, 'distance': distance};
    }).toList();

    // 5. Urutkan dari terdekat
    result.sort((a, b) =>
        (a['distance'] as double).compareTo(b['distance'] as double));

    setState(() {
      _currentPosition = position;
      _locationsWithDistance = result;
      _isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Reminder',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Bagian 1: Immediate Notification ---
            const Text('Notifikasi Langsung',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: const Text('Kirim Notifikasi Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: () async {
                await NotificationService().showInstantNotification(
                  title: 'Halo!',
                  body: 'Ini adalah contoh immediate notification.',
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifikasi dikirim!')),
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // --- Bagian 2: LBS (Lokasi Terdekat) ---
            const Text('Lokasi Terdekat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Cek Lokasi Saya'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
            ),
            if (_isLoadingLocation) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_currentPosition != null) ...[
              const SizedBox(height: 12),
              Text(
                'Posisi kamu: ${_currentPosition!.latitude.toStringAsFixed(5)}, '
                '${_currentPosition!.longitude.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ..._locationsWithDistance.map((item) {
                final loc = item['location'] as LocationData;
                final distance = item['distance'] as double;
                final isNear = distance < 150; // kurang dari 150 m = dekat
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isNear ? Colors.green.shade50 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isNear ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(children: [
                    Icon(Icons.location_on,
                        color: isNear ? Colors.green : Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loc.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isNear ? Colors.green.shade700 : Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      _formatDistance(distance),
                      style: TextStyle(
                        color: isNear ? Colors.green.shade700 : Colors.grey,
                        fontWeight: isNear ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (isNear) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 18),
                    ],
                  ]),
                );
              }),
            ],

            const SizedBox(height: 32),

            // --- Bagian 3: Set Reminder ke Lokasi ---
            const Text('Set Reminder ke Lokasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              'Pilih lokasi tujuan dan waktu. Notifikasi akan mengingatkanmu '
              'untuk cek jarak ke lokasi tersebut.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<LocationData?>(
              value: _selectedLocation,
              decoration: const InputDecoration(
                labelText: 'Pilih lokasi tujuan',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('Pilih lokasi...')),
                ...dummyLocations.map((loc) =>
                    DropdownMenuItem(value: loc, child: Text(loc.name))),
              ],
              onChanged: (val) => setState(() => _selectedLocation = val),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDateTime,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _scheduledTime == null
                          ? 'Pilih tanggal & waktu reminder...'
                          : _formatDateTime(_scheduledTime!),
                    ),
                  ),
                  if (_scheduledTime != null)
                    GestureDetector(
                      onTap: () => setState(() => _scheduledTime = null),
                      child:
                          const Icon(Icons.close, color: Colors.grey, size: 18),
                    ),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.alarm),
              label: const Text('Set Reminder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: _selectedLocation == null || _scheduledTime == null
                  ? null
                  : () async {
                      await NotificationService().scheduleNotification(
                        id: 1,
                        title: 'Reminder: ${_selectedLocation!.name}',
                        body: 'Buka app untuk cek seberapa jauh kamu '
                            'dari ${_selectedLocation!.name}',
                        scheduledTime: _scheduledTime!,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reminder ke ${_selectedLocation!.name} '
                              'di-set untuk ${_formatDateTime(_scheduledTime!)}',
                            ),
                          ),
                        );
                        setState(() {
                          _scheduledTime = null;
                          _selectedLocation = null;
                        });
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
```

### 6.8 Cara mencoba

1. Stop aplikasi lalu **run ulang** (bukan hot reload) agar permission baru terbaca.
2. Izinkan notifikasi dan lokasi saat muncul pop-up.
3. Tekan **Kirim Notifikasi Sekarang**, notifikasi harus muncul di status bar.
4. **Scheduled**: pilih tanggal hari ini dengan jam 1 sampai 2 menit ke depan, tekan **Set Reminder**,
   lalu tutup aplikasi dan tunggu. Notifikasi harus tetap muncul.
5. **LBS**: tekan **Cek Lokasi Saya**. Di emulator, lokasi default ada di Googleplex. Atur lewat tombol titik tiga
   emulator → **Location** → pilih titik → **Set Location** (misalnya dekat koordinat di `locations.dart`).

Kalau scheduled notification tidak muncul:
- Cek lagi semua permission dan receiver di `AndroidManifest.xml`.
- Cek desugaring di `build.gradle.kts`.
- Di HP: Settings → Apps → nama app → **Alarms & reminders** → izinkan.
- Coba di HP fisik, karena sebagian emulator terbatas untuk scheduled notification.

### 6.9 Ide menyambungkan ke aplikasi Skuy Nonton (latihan mandiri)

Contoh: tombol **"Ingatkan Saya Nonton"** di halaman detail, memanfaatkan `scheduleNotification()` dengan
`id` = id show agar tiap show punya reminder sendiri.

1. Salin `notification_service.dart` ke `lib/service/`, tambahkan dependency dan konfigurasi Android (6.1 sampai 6.3).
2. Di `main.dart`, tambahkan `await NotificationService().init();` setelah `WidgetsFlutterBinding.ensureInitialized();`.
3. Di `detail_page.dart`, tambahkan tombol (di bawah tombol favorit):

```dart
OutlinedButton.icon(
  icon: const Icon(Icons.alarm),
  label: const Text('Ingatkan Saya Nonton'),
  onPressed: () async {
    // pilih tanggal & jam dulu (pola sama seperti _pickDateTime di 6.7)
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    await NotificationService().scheduleNotification(
      id: show.id,
      title: 'Waktunya nonton!',
      body: 'Jangan lupa nonton ${show.name}',
      scheduledTime: DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
    Get.snackbar('Reminder', 'Pengingat untuk ${show.name} sudah diatur');
  },
),
```

---

## 7. Troubleshooting

| Masalah | Penyebab / solusi |
|---|---|
| Gambar/data tidak muncul | Cek koneksi internet; untuk release, pastikan permission `INTERNET` ada |
| `HiveError: Cannot read, unknown typeId` | `Hive.registerAdapter(FavoriteShowAdapter())` belum dipanggil sebelum `openBox`, atau `typeId` bentrok |
| Setelah mengubah model Hive aplikasi crash | Hapus data aplikasi / uninstall lalu run ulang |
| Tidak bisa login | Username harus sama dengan `kNim` di `constants.dart`, password `123` |
| `Get.find` error "not found" | Controller belum didaftarkan; cek `Binding` di `routes/app_pages.dart` |
