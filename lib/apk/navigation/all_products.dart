import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_apotek_unjaya/apk/models/cart_provider.dart';
import 'package:apk_apotek_unjaya/apk/navigation/shopping_cart_page.dart';
import 'package:apk_apotek_unjaya/apk/componen/ProductDetailPage.dart';
import 'package:apk_apotek_unjaya/apk/componen/drawer_menu.dart'; // Import DrawerMenu

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];
  String _searchQuery = "";

  Future<void> fetchAllProducts() async {
    final response =
    await http.get(Uri.parse('http://10.0.2.2:5000/api/products'));

    if (response.statusCode == 200) {
      setState(() {
        _allProducts = json.decode(response.body)['products'];
        _filteredProducts = _allProducts; // Inisialisasi awal
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _allProducts
          .where((product) =>
          product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.white,
        actions: [
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchProducts,
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0), // Membuat border bulat
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
              child: Text(
                _searchQuery.isEmpty
                    ? 'Tidak ada produk untuk ditampilkan.'
                    : 'Produk dengan kata kunci "$_searchQuery" tidak ditemukan.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.60,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Image.network(
                              'http://10.0.2.2:5000${product["image_url"]}',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rp ${product["price"]}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                          ElevatedButton(
                            onPressed: () {
                              cartProvider.addToCart({
                                "id": product["id"],
                                "name": product["name"],
                                "price": product["price"],
                                "image_url": "http://10.0.2.2:5000${product["image_url"]}",
                              });
                            },
                            child: const Text(
                              "+",
                              style: TextStyle(fontSize: 12), // Mengurangi ukuran font untuk tombol lebih kecil
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2), // Mengurangi padding lebih kecil
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6), // Menurunkan nilai borderRadius
                              ),
                              minimumSize: const Size(20, 20), // Mengurangi ukuran tombol lebih kecil
                            ),
                          ),


                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Menambahkan DrawerMenu ke dalam Scaffold
      bottomNavigationBar: DrawerMenu(
        onItemTapped: (index) {
          // Anda bisa menambahkan logika navigasi sesuai kebutuhan
        },
        selectedIndex: 1, // Produk adalah tab kedua
      ),
    );
  }
}
