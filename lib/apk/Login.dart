import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/SignUp.dart';
import 'package:apk_apotek_unjaya/apk/navigation/home.dart';
import 'package:apk_apotek_unjaya/apk/welcome_screen.dart';
import 'package:apk_apotek_unjaya/apk/api_service.dart';
import 'package:apk_apotek_unjaya/apk/admin_page/admin_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isPasswordVisible = false;

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await ApiService.loginUser(context, email, password);

      if (response.containsKey('message')) {
        final bool isAdmin = response['is_admin'] ?? false;
        final String? username = response['user']?['name'];

        if (username == null) {
          throw Exception('Invalid response: username is null');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        String? token = await ApiService.getToken();
        int? userId = await ApiService.getUserId();
        print('Token: $token');
        print('User ID: $userId');

        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'] ?? 'Unknown error occurred')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
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
            Column(
              children: [
                Image.asset(
                  'assets/images/logo-apk.png',
                  width: 100,
                  height: 100,
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
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Masukan password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Lupa Password?'),
              ),
            ),
            const SizedBox(height: 16),
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
            const Spacer(),
            const Text(
              'Or',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
