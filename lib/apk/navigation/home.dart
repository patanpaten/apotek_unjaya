import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/daftar 17.43.11.dart'; // Contoh halaman daftar
import 'package:apk_apotek_unjaya/apk/category_produk/demam.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/category_produk/flu_batuk_alergi.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/category_produk/herbal.dart'; // Halaman Cek Kesehatan
import 'package:apk_apotek_unjaya/apk/category_produk/vitamin.dart'; // Halaman Cek Kesehatan

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategorySection(context),
              const SizedBox(height: 16),
              _buildPopularProducts(),
            ],
          ),
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
          const Herbal(), // Navigasi ke halaman Herbal
        ),
        _buildCategoryIcon(
          context,
          "Vitamin",
          "assets/images/obat-bebas.png",
          const Vitamin(), // Navigasi ke halaman Bebas
        ),
        _buildCategoryIcon(
          context,
          "Demam",
          "assets/images/obat-genetik.png",
          const Demam(), // Navigasi ke halaman Genetik
        ),
        _buildCategoryIcon(
          context,
          "Flu Batuk Alergi",
          "assets/images/cek_kesehatan.png",
          const FluBatukAlergi(), // Navigasi ke halaman Cek Kesehatan
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(
      BuildContext context, String title, String imagePath, Widget targetPage) {
    return InkWell(
      onTap: () {
        // Navigasi ke halaman target
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
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  

  Widget _buildPopularProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Product",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildProductCard(
                  "Panadol", "20pcs", "assets/images/obat-panadol.png", 15.99),
              _buildProductCard("Bodrex Herbal", "100ml",
                  "assets/images/obat-bodrek.png", 7.99),
              _buildProductCard(
                  "Konidin", "3pcs", "assets/images/obat-konidin.png", 5.99),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
      String name, String quantity, String imagePath, double price) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  quantity,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$$price",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.teal),
                      onPressed: () {
                        ('Added $name to cart!');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
