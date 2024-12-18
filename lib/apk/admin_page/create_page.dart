import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/admin_componen/add_produk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apk_apotek_unjaya/apk/admin_componen/edit_produk.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  List<dynamic> _products = [];  // List untuk menyimpan produk

  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/products'));  // Gunakan 10.0.2.2 untuk emulator

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body)['products'];  // Menyimpan data produk ke dalam list
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fungsi untuk menghapus produk
  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:5000/api/products/$productId'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product deleted successfully!')));
      fetchProducts(); // Perbarui daftar produk setelah dihapus
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete product')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();  // Memanggil fungsi fetchProducts saat halaman dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman AddProdukPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProdukPage()),
                );
              },
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 16),  // Jarak antara tombol dan daftar produk
            Text(
              'Product List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _products.isEmpty
                  ? Center(child: CircularProgressIndicator())  // Loading indicator saat data masih kosong
                  : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,  // Ukuran gambar yang lebih kecil
                        height: 50,
                        child: Image.network(
                          'http://10.0.2.2:5000${_products[index]['image_url']}',  // Gunakan URL gambar yang benar
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(_products[index]['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: \$${_products[index]['price']}'),
                          Text('Stock: ${_products[index]['stock']}'),  // Menambahkan stok produk
                          SizedBox(height: 8),  // Jarak antara stok dan deskripsi
                          Text('Description: ${_products[index]['description']}'),  // Menambahkan deskripsi produk
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Navigasi ke halaman EditProductPage dengan ID produk yang akan diedit
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductPage(productId: _products[index]['id']),
                                ),
                              ).then((isUpdated) {
                                if (isUpdated == true) {
                                  fetchProducts(); // Perbarui daftar produk setelah berhasil diupdate
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Menampilkan dialog konfirmasi sebelum menghapus
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete this product?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();  // Menutup dialog jika pilih Tidak
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteProduct(_products[index]['id']); // Hapus produk jika pilih Ya
                                        Navigator.of(context).pop();  // Menutup dialog setelah hapus
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
