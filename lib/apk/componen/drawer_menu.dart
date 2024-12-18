import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/navigation/home.dart';
import 'package:apk_apotek_unjaya/apk/navigation/riwayat.dart';
import 'package:apk_apotek_unjaya/apk/navigation/akun.dart';
import 'package:apk_apotek_unjaya/apk/navigation/all_products.dart'; // Import halaman All Products
import 'package:apk_apotek_unjaya/apk/navigation/user_account.dart'; // Import halaman UserAccount

class DrawerMenu extends StatefulWidget {
  final Function(int) onItemTapped; // Callback untuk aksi tab
  final int selectedIndex; // Indeks yang sedang aktif

  const DrawerMenu({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting, // Animasi shifting
      backgroundColor: Colors.teal, // Warna latar belakang
      currentIndex: widget.selectedIndex, // Indeks aktif
      selectedItemColor: Colors.white, // Warna untuk item yang aktif
      unselectedItemColor: Colors.black54, // Warna untuk item tidak aktif
      onTap: (int index) {
        if (index == 0) {
          // Jika Home diklik
          Navigator.popUntil(context, (route) => route.isFirst); // Kembali ke halaman pertama (Home)
        } else if (index == 1) {
          // Jika Produk diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AllProductsPage(),
            ),
          );
        } else if (index == 3) {
          // Jika Akun diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserAccountPage(),
            ),
          );
        } else {
          // Panggil callback untuk indeks lainnya
          widget.onItemTapped(index);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Produk',
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Akun',
          backgroundColor: Colors.teal,
        ),
      ],
    );
  }
}
