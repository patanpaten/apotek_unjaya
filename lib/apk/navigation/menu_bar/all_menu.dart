import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/navigation/konsultasi_dokter.dart';
import 'package:apk_apotek_unjaya/apk/navigation/riwayat.dart';
import 'package:apk_apotek_unjaya/apk/navigation/akun.dart';
import 'package:apk_apotek_unjaya/apk/navigation/home.dart';



class AllMenu extends StatefulWidget {
  const AllMenu({super.key});

  @override
  _AllMenuState createState() => _AllMenuState();
}

class _AllMenuState extends State<AllMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const KonsultasiDokter(),
    const Riwayat(),
    const Akun(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _pages[_currentIndex], // Menampilkan halaman sesuai tab yang dipilih
        ),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: 'Konsultasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Akun',
            ),
          ],
        ),
      ],
    );
  }
}
