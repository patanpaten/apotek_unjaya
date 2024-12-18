import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:apk_apotek_unjaya/apk/models/article_model.dart';
import 'package:apk_apotek_unjaya/apk/services/article_service.dart';

class EditArticleScreen extends StatefulWidget {
  final Article article;

  EditArticleScreen({required this.article});

  @override
  _EditArticleScreenState createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  File? _image;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data artikel yang ada
    _titleController = TextEditingController(text: widget.article.title);
    _contentController = TextEditingController(text: widget.article.content);
  }

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

  // Fungsi untuk mengupdate artikel
  Future<void> _updateArticle() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;

      try {
        var request = http.MultipartRequest('PUT', Uri.parse('http://10.0.2.2:5000/api/articles/${widget.article.id}'));

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

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Artikel berhasil diperbarui!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal update artikel: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error saat update artikel: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat mengupdate artikel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Article')),
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
                  : widget.article.imageUrl != null && widget.article.imageUrl!.isNotEmpty
                  ? Image.network(
                'http://10.0.2.2:5000${widget.article.imageUrl}',
                height: 150,
                fit: BoxFit.cover,
              )
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateArticle,
                child: Text('Update Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
