import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }
  void _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final adaLogin = prefs.getBool('loginData') ?? false;
    if (adaLogin && mounted) {
      Get.offAllNamed(AppRoutes.main);
    }
  }
  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == '124240049' && password == '123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loginData', true);
      await prefs.setString('username', username);
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.snackbar(
        'Login gagal',
        'Username atau password salah.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.movie_outlined, size: 72, color: Colors.red),
                const SizedBox(height: 8),
                const Text(
                  'Skuy Nonton!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
                  decoration: _inputDecoration('Username', Icons.person_outline),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration('Password', Icons.lock_outline),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Color(0xFF1C1C1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
