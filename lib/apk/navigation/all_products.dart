import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package for formatting

// Model Product untuk memetakan data produk dari API
class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      // Perbaiki konversi price dari String menjadi double
      price: double.tryParse(json['price'].toString()) ?? 0.0, // Jika gagal konversi, nilai default 0.0
      stock: json['stock'],
      description: json['description'],
    );
  }
}

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  // Daftar produk yang akan ditampilkan
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/products'));

      if (response.statusCode == 200) {
        // Parsing respons JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Memastikan bahwa data produk berada di dalam kunci 'products'
        if (responseData.containsKey('products')) {
          final List<dynamic> productJson = responseData['products'];

          setState(() {
            // Mengubah data JSON menjadi objek Product
            _products = productJson.map((json) => Product.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Products key not found in response';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load products';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();  // Ambil data produk saat halaman pertama kali dimuat
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0.00", "en_US"); // Format angka untuk harga produk

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator jika data belum diambil
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 4,
            child: ListTile(
              title: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${numberFormat.format(product.price)}', style: TextStyle(fontSize: 14)),
                  Text('Stock: ${product.stock}', style: TextStyle(fontSize: 14)),
                ],
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Aksi ketika produk di-tap (misalnya membuka halaman detail produk)
                // Anda bisa menambahkan routing ke halaman detail produk di sini
              },
            ),
          );
        },
      ),
    );
  }
}
