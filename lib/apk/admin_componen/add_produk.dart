import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AddProdukPage extends StatefulWidget {
  @override
  _AddProdukPageState createState() => _AddProdukPageState();
}

class _AddProdukPageState extends State<AddProdukPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  // Fungsi untuk menambahkan produk
  Future<void> addProduct() async {
    if (_image == null || _nameController.text.isEmpty || _priceController.text.isEmpty || _stockController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Silakan lengkapi semua kolom')));
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:5000/api/products'));

    // Menambahkan file gambar
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    // Menambahkan data form
    request.fields['name'] = _nameController.text;
    request.fields['price'] = _priceController.text;
    request.fields['stock'] = _stockController.text;
    request.fields['description'] = _descriptionController.text;

    try {
      // Mengirim request ke server
      var response = await request.send();

      // Menangani respons server
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produk berhasil ditambahkan')));
        setState(() {
          _image = null;  // Reset gambar setelah berhasil ditambahkan
          _nameController.clear();
          _priceController.clear();
          _stockController.clear();
          _descriptionController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menambahkan produk')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk Baru'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Nama produk
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            SizedBox(height: 8),
            // Harga produk
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            // Stok produk
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            // Deskripsi produk
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 8),
            // Tombol untuk memilih gambar
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pilih Gambar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            // Menampilkan gambar yang dipilih
            _image != null
                ? Image.file(
              _image!,
              width: MediaQuery.of(context).size.width * 0.5,
              height: 150,
              fit: BoxFit.cover,
            )
                : Text('Belum ada gambar'),
            SizedBox(height: 16),
            // Tombol untuk menambahkan produk
            Center(
              child: ElevatedButton(
                onPressed: addProduct,
                child: Text('Tambah Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
