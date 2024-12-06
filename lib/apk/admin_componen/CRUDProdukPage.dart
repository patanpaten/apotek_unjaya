import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk decode JSON
import 'package:http/http.dart' as http; // Untuk API call
import 'package:apk_apotek_unjaya/apk/admin_componen/add_produk.dart; // Impor AddProductPage yang benar

class CRUDProdukPage extends StatefulWidget {
  @override
  _CRUDProdukPageState createState() => _CRUDProdukPageState();
}

class _CRUDProdukPageState extends State<CRUDProdukPage> {
  List<dynamic> _products = []; // Menyimpan daftar produk

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fungsi untuk memuat produk dari API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/products')); // Gunakan 10.0.2.2 untuk Android Emulator
    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body)['products'];
      });
    } else {
      // Error handling
      print('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Produk'),
        backgroundColor: Colors.teal,
      ),
      body: _products.isEmpty
          ? Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProdukPage(), // Menambahkan halaman AddProductPage
            );

            // Jika produk berhasil ditambahkan, muat ulang data produk
            if (result == true) {
              fetchProducts();
            }
          },
          child: Text('Tambah Produk'),
        ),
      )
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: product['image_url'] != null
                  ? Image.network(
                product['image_url'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.image_not_supported),
              title: Text(product['name']),
              subtitle: Text('Harga: ${product['price']} | Stok: ${product['stock']}'),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    // Navigasi ke halaman edit produk
                    Navigator.pushNamed(context, '/editProduct', arguments: product);
                  } else if (value == 'delete') {
                    // Panggil API untuk menghapus produk
                    deleteProduct(product['id']);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Fungsi untuk menghapus produk
  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:5000/api/products/$id')); // Gunakan 10.0.2.2 untuk Android Emulator
    if (response.statusCode == 200) {
      setState(() {
        _products.removeWhere((product) => product['id'] == id);
      });
    } else {
      print('Failed to delete product');
    }
  }
}
