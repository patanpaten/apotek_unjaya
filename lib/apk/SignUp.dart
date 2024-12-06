import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/Login.dart';
import 'package:apk_apotek_unjaya/apk/api_service.dart'; // Import ApiService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false; // Variabel untuk visibilitas password
  bool _isConfirmPasswordVisible = false; // Variabel untuk visibilitas confirm password

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  // Fungsi untuk menangani pendaftaran
  void _handleRegister() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validasi input sebelum mengirim request
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password and Confirm Password do not match')),
      );
      return;
    }

    // Call the register API
    try {
      final response = await ApiService.registerUser(name, email, password, confirmPassword);
      if (response.containsKey('message')) {
        // Success: show success message and navigate to login page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Error: show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'])),
        );
      }
    } catch (e) {
      // Error handling jika API gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo dan Judul
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo-apk.png', // Path gambar logo
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Daftar dan mulai pengalaman baru!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Form Input
              _buildTextField('Name', Icons.person, controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField('Email', Icons.email, controller: _emailController),
              const SizedBox(height: 16),
              _buildPasswordTextField('Password', Icons.lock, controller: _passwordController, isPassword: true),
              const SizedBox(height: 16),
              _buildPasswordTextField('Confirm Password', Icons.lock, controller: _confirmPasswordController, isPassword: true),
              const SizedBox(height: 20),
              // Tombol Daftar
              ElevatedButton(
                onPressed: _handleRegister, // Handle registration here
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal, // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              // Pilihan Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: () {
                      // Navigasi ke layar login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // Widget untuk password field dengan toggle visibilitas
  Widget _buildPasswordTextField(String label, IconData icon, {TextEditingController? controller, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(
            isPassword
                ? (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                : (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
          ),
          onPressed: () {
            setState(() {
              if (isPassword) {
                _isPasswordVisible = !_isPasswordVisible;
              } else {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              }
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}