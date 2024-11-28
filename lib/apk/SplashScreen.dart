import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/login.dart';
import 'package:apk_apotek_unjaya/apk/SignUp.dart'; // Ganti dengan path halaman sign up Anda
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunggu 7 detik sebelum pindah ke halaman berikutnya
    Timer(const Duration(seconds: 7), _navigateToNextScreen);
  }

  // Fungsi untuk navigasi ke halaman utama (tombol Login dan Sign Up)
  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()), // Ganti dengan halaman berikutnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-apk.png', // Path gambar logo
              width: 150, // Ukuran logo
              height: 150, // Ukuran logo
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // Menampilkan loading saat animasi
          ],
        ),
      ),
    );
  }
}
