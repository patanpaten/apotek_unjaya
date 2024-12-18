import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apk_apotek_unjaya/apk/componen/drawer_menu.dart'; // Komponen DrawerMenu
import 'package:apk_apotek_unjaya/apk/navigation/home_content.dart';
import 'package:apk_apotek_unjaya/apk/Login.dart';
import 'package:apk_apotek_unjaya/apk/navigation/shopping_cart_page.dart'; // Mengimpor ShoppingCartPage
import 'package:apk_apotek_unjaya/apk/models/cart_provider.dart'; // Mengimpor CartProvider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List halaman berdasarkan tab yang dipilih
  static const List<Widget> _pages = <Widget>[
    HomeContent(), // Konten utama Home
    // Tambahkan halaman lain jika diperlukan
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk logout
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigasi ke halaman Login
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MediSync"),
        actions: [
          // Ikon notifikasi tetap terpisah
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifikasi');
            },
          ),

          // Ikon shopping cart dengan badge merah
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartPage(),
                    ),
                  );
                },
              ),
              if (cartProvider.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartProvider.cartCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Konten berubah sesuai tab
      bottomNavigationBar: DrawerMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
