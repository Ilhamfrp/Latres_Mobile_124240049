import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/favorite_show.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/constants.dart';

void main() async {
  // Wajib karena main() async dan ada await di dalamnya (Modul 6).
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive, daftarkan adapter, lalu buka box favorit.
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteShowAdapter());
  await Hive.openBox<FavoriteShow>(kFavBox);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp (bukan MaterialApp) agar navigasi GetX bisa dipakai.
    return GetMaterialApp(
      title: 'Skuy Nonton!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: kAccent),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: kAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccent,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.login, // LoginPage akan cek session sendiri
      getPages: AppPages.routes,
    );
  }
}
