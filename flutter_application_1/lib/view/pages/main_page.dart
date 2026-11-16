import 'package:flutter/material.dart';

import 'favorite_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

/// Kerangka utama: BottomNavigationBar untuk pindah Home / Favorit / Profil.
/// Pakai StatefulWidget + setState seperti di Modul 3 (state sederhana
/// yang hanya dipakai satu widget, jadi tidak perlu GetX).
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Tidak const karena HomePage dkk mengambil controller lewat Get.find().
  final List<Widget> _pages = [HomePage(), FavoritePage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga state tiap halaman saat berpindah tab.
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
