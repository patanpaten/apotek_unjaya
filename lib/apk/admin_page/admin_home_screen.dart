import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/login.dart'; // Mengimpor LoginScreen
import 'package:apk_apotek_unjaya/apk/admin_page/dashboard_admin.dart'; // Import DashboardPage
import 'package:apk_apotek_unjaya/apk/admin_page/create_page.dart'; // Import CreatePage
import 'package:apk_apotek_unjaya/apk/admin_componen/article_management_screen.dart'; // Import halaman artikel
import 'package:apk_apotek_unjaya/apk/admin_componen/PromotionSection.dart'; // Mengimpor PromotionSection
import 'package:apk_apotek_unjaya/apk/admin_componen/purchase_screen.dart'; // Mengimpor halaman pembelian

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang relevan
  final List<Widget> _pages = [
    DashboardPage(), // Indeks 0
    PurchaseScreen(), // Indeks 1 (Halaman Pembelian)
    ArticleManagementScreen(), // Indeks 2 (Halaman Artikel CRUD)
    CreatePage(), // Indeks 3 (Halaman Produk)
    PromotionSection(), // Indeks 4 (Halaman Promosi)
  ];

  // Fungsi untuk logout
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Menangani aksi logout
          ),
        ],
      ),
      body: _pages[_currentIndex], // Menampilkan halaman sesuai tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pembelian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Promosi',
          ),
        ],
      ),
    );
  }
}
