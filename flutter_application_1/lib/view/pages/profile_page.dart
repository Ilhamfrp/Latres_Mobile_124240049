import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';
import '../../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '-';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Ambil username yang disimpan saat login (SharedPreferences).
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(kPrefUsername) ?? '-';
    });
  }

  // Modul 6 (_logout): hapus session lalu kembali ke login dan
  // buang semua halaman sebelumnya.
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kPrefLoggedIn);
    await prefs.remove(kPrefUsername);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 44,
                backgroundColor: kCard,
                child: Icon(Icons.person, size: 48, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                _username,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                kKesanPesan,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _logout, child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}
