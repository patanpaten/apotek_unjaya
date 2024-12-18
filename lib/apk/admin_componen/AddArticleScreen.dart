import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddArticleScreen extends StatefulWidget {
  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk menambahkan artikel
  Future<void> _submitArticle() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;

      try {
        var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5000/api/articles'));

        // Menambahkan data artikel
        request.fields['title'] = title;
        request.fields['content'] = content;

        // Menambahkan gambar jika ada
        if (_image != null) {
          var pic = await http.MultipartFile.fromPath('image', _image!.path);
          request.files.add(pic);
        }

        // Mengirimkan request
        var response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Artikel berhasil ditambahkan!')),
          );
          Navigator.pop(context);
        } else {
          // Jika gagal, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal upload artikel: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error saat upload artikel: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat mengupload artikel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick an Image'),
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(
                _image!,
                height: 150,
                fit: BoxFit.cover,
              )
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitArticle,
                child: Text('Submit Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
