import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductPage extends StatefulWidget {
  final int productId;

  EditProductPage({required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();

  File? _image; // Menyimpan gambar yang dipilih
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk mengambil data produk dari API dan menampilkan di form
  Future<void> fetchProductDetails() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/products/${widget.productId}'));

    if (response.statusCode == 200) {
      final product = json.decode(response.body);
      if (product != null && product['name'] != null) {
        setState(() {
          _nameController.text = product['name'];
          _priceController.text = product['price'].toString();
          _descriptionController.text = product['description'];
          _stockController.text = product['stock'].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product not found')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load product')));
    }
  }

  // Fungsi untuk mengupdate produk
  Future<void> updateProduct() async {
    String? imageUrl;
    bool imageUpdated = false;

    // Jika gambar baru dipilih, upload gambar tersebut
    if (_image != null) {
      imageUrl = await uploadImage(_image!); // Mengupload gambar baru
      imageUpdated = true;
    }

    // Hanya kirim data yang berubah
    Map<String, dynamic> productData = {
      'name': _nameController.text,
      'price': _priceController.text,
      'description': _descriptionController.text,
      'stock': _stockController.text,
    };

    // Jika gambar diperbarui, tambahkan URL gambar yang baru
    if (imageUpdated) {
      productData['image_url'] = imageUrl;
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5000/api/products/${widget.productId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated successfully!')));
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya setelah berhasil
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product')));
    }
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Menyimpan file gambar yang dipilih
      });
    }
  }

  // Fungsi untuk mengupload gambar ke server
  Future<String> uploadImage(File image) async {
    try {
      final uri = Uri.parse('http://10.0.2.2:5000/api/products/upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['image_url']; // Mengembalikan URL gambar yang diupload
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails(); // Ambil data produk ketika halaman dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Menampilkan gambar produk jika ada gambar yang dipilih
            _image != null
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.file(
                _image!,
                width: MediaQuery.of(context).size.width * 0.5,
                height: 150,
                fit: BoxFit.cover,
              ),
            )
                : SizedBox.shrink(), // Jika gambar tidak ada, tampilkan kosong

            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pilih Gambar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            _image == null
                ? Text('Belum ada gambar')
                : Text('Gambar telah dipilih'),
            SizedBox(height: 16),

            // Form untuk mengedit produk
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProduct,
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
