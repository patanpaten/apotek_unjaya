import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:apk_apotek_unjaya/apk/models/cart_provider.dart';
import 'package:apk_apotek_unjaya/apk/navigation/all_products.dart';
import 'package:apk_apotek_unjaya/apk/componen/ProductDetailPage.dart';

class ProductSection extends StatefulWidget {
  final List<Map<String, String>> products;

  const ProductSection({super.key, required this.products});

  @override
  _ProductSectionState createState() => _ProductSectionState();
}

class _ProductSectionState extends State<ProductSection> {
  List<dynamic> _products = [];

  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/products'));

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body)['products'];
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

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
          height: 220,
          child: _products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _products.length > 4 ? 4 : _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return GestureDetector(
                onTap: () {
                  // Navigasi ke halaman detail produk
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4.0,
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'http://10.0.2.2:5000${product["image_url"]}',
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
                                  final productData = {
                                    "id": product["id"],
                                    "name": product["name"],
                                    "price": double.tryParse(product["price"]) ?? 0.0,
                                    "image_url": "http://10.0.2.2:5000${product["image_url"]}",
                                    "quantity": 1,
                                  };

                                  Provider.of<CartProvider>(context, listen: false)
                                      .addToCart(productData);
                                  print("Ditambahkan ke keranjang: ${product["name"]}");
                                },
                                child: const Icon(Icons.add, size: 16),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  backgroundColor: Colors.teal,
                                  minimumSize: const Size(30, 30),
                                  shape: const CircleBorder(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
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
