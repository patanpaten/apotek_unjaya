import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/SignUp.dart'; // Contoh halaman daftar
import 'package:apk_apotek_unjaya/apk/category_produk/demam.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/category_produk/flu_batuk_alergi.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/category_produk/herbal.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/category_produk/vitamin.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/navigation/konsultasi_dokter.dart'; // Halaman Konsultasi Dokter
import 'package:apk_apotek_unjaya/apk/navigation/riwayat.dart'; // Halaman Riwayat
import 'package:apk_apotek_unjaya/apk/navigation/akun.dart'; // Halaman Akun

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: const AssetImage("assets/images/pp.png"),
              backgroundColor: Colors.grey[200], // Placeholder jika gambar tidak ditemukan
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "WELCOME TO MEDISYCN",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(  // Sudah benar, halaman bisa di-scroll
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategorySection(context),
              const SizedBox(height: 16),
              _buildAdvertisement(),
              const SizedBox(height: 16),
              _buildPopularProducts(context),
              const SizedBox(height: 16),
              _buildHealthArticles(),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Konsultasi Dokter'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KonsultasiDokter()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Riwayat()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Akun'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Akun()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.search),
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryIcon(
          context,
          "Herbal",
          "assets/images/obat-herbal.png",
          const Herbal(),
        ),
        _buildCategoryIcon(
          context,
          "Vitamin",
          "assets/images/obat-bebas.png",
          const Vitamin(),
        ),
        _buildCategoryIcon(
          context,
          "Demam",
          "assets/images/obat-genetik.png",
          const Demam(),
        ),
        _buildCategoryIcon(
          context,
          "Flu Batuk Alergi",
          "assets/images/cek_kesehatan.png",
          const FluBatukAlergi(),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(
      BuildContext context, String title, String imagePath, Widget targetPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal[50],
            radius: 30,
            backgroundImage: AssetImage(imagePath),
            onBackgroundImageError: (exception, stackTrace) {
              ('Error loading image: $imagePath');
            },
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan iklan
  Widget _buildAdvertisement() {
    return Container(
      height: 120,  // Mengurangi tinggi iklan
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.teal[50],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/iklan.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPopularProducts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menggunakan Row untuk judul dan tombol See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Popular Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Arahkan ke halaman produk lengkap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllProductsPage()),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(
                    color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildProductCard(
                  "Panadol", "20pcs", "assets/images/panadol 2.jpg", 15.99),
              _buildProductCard("Bodrex Herbal", "100ml",
                  "assets/images/bodrex.png", 7.99),
              _buildProductCard(
                  "Konidin", "3pcs", "assets/images/obat-konidin.png", 5.99),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Memindahkan tombol "See All" di samping judul artikel
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Artikel Kesehatan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Arahkan ke halaman artikel lengkap
              },
              child: const Text(
                "See All",
                style: TextStyle(
                    color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Daftar artikel kesehatan (contoh)
        _buildHealthArticleCard("Flu dan Batuk", "Gejala dan pengobatan flu", "assets/images/flu.png"),
        _buildHealthArticleCard("Kesehatan Jantung", "Menjaga kesehatan jantung", "assets/images/jantung.png"),
      ],
    );
  }

  Widget _buildHealthArticleCard(
      String title, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, height: 120, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      String productName, String productDetails, String imagePath, double price) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, width: 100, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(productDetails),
          ),
          // Menampilkan harga di samping tombol "+"
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    // Aksi saat tombol "+" ditekan
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman untuk daftar semua produk (contoh)
class AllProductsPage extends StatelessWidget {
  const AllProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: const Center(
        child: Text("Daftar Produk Lengkap"),
      ),
    );
  }
}
