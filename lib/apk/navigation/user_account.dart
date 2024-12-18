import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/navigation/home.dart'; // Pastikan path ini sesuai
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:apk_apotek_unjaya/apk/Login.dart';
import 'package:apk_apotek_unjaya/apk/navigation/all_products.dart';
import 'package:apk_apotek_unjaya/apk/componen/drawer_menu.dart'; // Pastikan impor DrawerMenu

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({Key? key}) : super(key: key);

  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  String _username = '';
  String _email = '';
  String _phoneNumber = '';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _email = prefs.getString('email') ?? 'example@email.com';
      _phoneNumber = prefs.getString('phone_number') ?? 'No phone number';
      String? profileImagePath = prefs.getString('profile_image');
      if (profileImagePath != null) {
        _profileImage = File(profileImagePath);
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Account'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/images/default-profile.png') as ImageProvider,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Username: $_username',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $_email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone: $_phoneNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DrawerMenu(
        onItemTapped: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti HomePage dengan HomeScreen
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AllProductsPage()),
            );
          }
        },
        selectedIndex: 3, // Update dengan indeks yang sesuai
      ),
    );
  }
}
