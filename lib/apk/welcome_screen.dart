import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/Login.dart';  // Pastikan Anda mengimpor halaman Login.dart
import 'package:apk_apotek_unjaya/apk/SignUp.dart';  // Pastikan Anda mengimpor halaman Register.dart (SignUp)

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Background warna welcome screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animasi
            Image.asset(
              'assets/images/logo-apk.png',  // Ganti dengan path logo Anda
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang di MediSync',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Login
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Sign Up
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Sign Up
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
