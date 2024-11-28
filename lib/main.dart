import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/welcome_screen.dart';  // Mengimpor halaman WelcomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),  // Halaman splash screen pertama kali muncul
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}

// Halaman SplashScreen dengan animasi logo
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay sebelum berpindah halaman setelah animasi
    Future.delayed(const Duration(seconds: 4), () {
      // Menavigasi ke halaman WelcomeScreen setelah animasi selesai
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()), // Pindah ke halaman welcome
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Background warna splash screen
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 2),  // Durasi animasi logo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animasi
              Image.asset(
                'assets/images/logo-apk.png',  // Pastikan path gambar benar
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'MediSync',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
