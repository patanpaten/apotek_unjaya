import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/navigation/all_products.dart';

class ProductSection extends StatelessWidget {
  final List<Map<String, String>> products;

  const ProductSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Produk Populer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigasi langsung ke halaman AllProductsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllProductsPage()),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(fontSize: 14, color: Colors.teal),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        SizedBox(
          height: 220, // Atur tinggi sesuai kebutuhan
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4.0,
                  child: Container(
                    width: 150, // Atur lebar produk sesuai kebutuhan
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/bodrex.png', // Ganti dengan gambar produk
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product["name"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp ${product["price"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print("Ditambahkan ke keranjang: ${product["name"]}");
                              },
                              child: const Icon(Icons.add, size: 16), // Ikon "+"
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(4), // Ukuran tombol lebih kecil
                                backgroundColor: Colors.teal,
                                minimumSize: const Size(30, 30),
                                shape: const CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
