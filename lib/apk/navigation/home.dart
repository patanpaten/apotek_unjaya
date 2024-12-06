// Import di bagian atas file
import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/navigation/konsultasi_dokter.dart';
import 'package:apk_apotek_unjaya/apk/navigation/riwayat.dart';
import 'package:apk_apotek_unjaya/apk/navigation/akun.dart';
import 'package:apk_apotek_unjaya/apk/componen/product_section.dart'; // Komponen Produk
import 'package:apk_apotek_unjaya/apk/componen/article_section.dart'; // Komponen Artikel
import 'package:apk_apotek_unjaya/apk/navigation/user_account.dart'; // Komponen UserAccount
import 'package:apk_apotek_unjaya/apk/componen/drawer_menu.dart'; // Komponen DrawerMenu
import 'package:apk_apotek_unjaya/apk/admin_page/create_page.dart'; // Pastikan CreatePage dipisahkan menjadi file lain

// Halaman Home untuk User
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List halaman berdasarkan tab yang dipilih
  static const List<Widget> _pages = <Widget>[
    HomeContent(),
    KonsultasiDokter(),
    Riwayat(),
    Akun(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MediSync"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifikasi');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/keranjang');
            },
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

// Halaman konten utama Home untuk User
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Data produk dan artikel yang ditampilkan
    final List<Map<String, String>> products = [
      {'name': 'Paracetamol', 'price': '5000'},
      {'name': 'Vitamin C', 'price': '7000'},
      {'name': 'Obat Batuk', 'price': '15000'},
    ];

    final List<Map<String, String>> articles = [
      {'title': 'Tips Sehat di Musim Hujan', 'content': 'Cara menjaga kesehatan selama musim hujan...'},
      {'title': 'Manfaat Vitamin C', 'content': 'Vitamin C sangat baik untuk meningkatkan imun tubuh...'},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            UserAccount(
              userName: "John Doe",
              email: "johndoe@example.com",
              profileImage: "assets/images/profile_pic.png",
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 20),
            ProductSection(products: products),
            const SizedBox(height: 20),
            ArticleSection(articles: articles),
          ],
        ),
      ),
    );
  }
}

// Halaman Dashboard Admin
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePage()), // Navigasi ke CreatePage
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Dashboard Admin',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
