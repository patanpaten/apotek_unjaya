import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/SignUp.dart';
import 'package:apk_apotek_unjaya/apk/navigation/home.dart';
import 'package:apk_apotek_unjaya/apk/welcome_screen.dart';  // Mengimpor halaman WelcomeScreen
import 'package:apk_apotek_unjaya/apk/api_service.dart';
import 'package:apk_apotek_unjaya/apk/admin_page/dashboard_admin.dart';
import 'package:apk_apotek_unjaya/apk/admin_page/admin_home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variabel untuk mengatur visibilitas password
  bool _isPasswordVisible = false;

  // Fungsi untuk menangani login

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await ApiService.loginUser(email, password);

    if (response.containsKey('message')) {
      final bool isAdmin = response['is_admin'] ?? false;

      if (isAdmin) {
        // Jika admin, langsung masuk ke halaman admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()), // Halaman Admin
        );
      } else {
        // Jika user biasa, masuk ke halaman user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Halaman User biasa
        );
      }
    } else {
      // Tampilkan pesan error jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigasi kembali ke halaman WelcomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo dan Judul
            Column(
              children: [
                Image.asset(
                  'assets/images/logo-apk.png', // Path gambar logo
                  width: 100, // Lebar gambar
                  height: 100, // Tinggi gambar
                ),
                const SizedBox(height: 16),
                const Text(
                  'MediSycn',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Let\'s get started!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Masukan email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,  // Menampilkan atau menyembunyikan password
              decoration: InputDecoration(
                labelText: 'Masukan password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Toggle icon
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Lupa Password?'),
              ),
            ),
            const SizedBox(height: 16),
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
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
            ),
            const SizedBox(height: 16),
            // Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Daftar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // OR Divider
            const Row(
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('OR'),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 16),
            // Social Media Login Buttons with Images
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle Google login
                    debugPrint('Google login button pressed');
                  },
                  child: Image.asset(
                    'assets/images/logo_google.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // Handle Facebook login
                    debugPrint('Facebook login button pressed');
                  },
                  child: Image.asset(
                    'assets/images/fb2.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // Handle Apple login
                    debugPrint('Apple login button pressed');
                  },
                  child: Image.asset(
                    'assets/images/Appel.jpg', // Path gambar logo Apple
                    width: 50, // Ukuran logo Apple
                    height: 50, // Ukuran logo Apple
                  ),
                ),
                const SizedBox(width:16),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
