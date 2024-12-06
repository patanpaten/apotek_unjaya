import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/navigation/home.dart';
import 'package:apk_apotek_unjaya/apk/navigation/konsultasi_dokter.dart';
import 'package:apk_apotek_unjaya/apk/navigation/riwayat.dart';
import 'package:apk_apotek_unjaya/apk/navigation/akun.dart';

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
      onTap: widget.onItemTapped, // Callback untuk perubahan indeks
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Konsultasi',
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
