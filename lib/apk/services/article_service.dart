import 'dart:convert';
import 'dart:io'; // Untuk File
import 'package:http/http.dart' as http;
import 'package:apk_apotek_unjaya/apk/models/article_model.dart';

class ArticleService {
  static const String _baseUrl = 'http://10.0.2.2:5000';  // Ganti dengan URL server Anda

  // Fungsi untuk mengambil daftar artikel
  static Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/articles'));

    if (response.statusCode == 200) {
      // Mengambil data dari properti 'articles' yang berisi list artikel
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Mengambil data dari kunci 'articles', pastikan tidak null
      final List<dynamic> data = jsonData['articles'] ?? []; // Fallback ke List kosong jika 'articles' null

      // Memetakan data ke dalam List<Article> jika data ada
      return data.map((json) => Article.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }




  // Fungsi untuk menghapus artikel berdasarkan ID
  static Future<void> deleteArticle(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/api/articles/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete article');
    }
  }

  // Fungsi untuk menambahkan artikel
  static Future<void> uploadArticle(String title, String content) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/articles'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );

    if (response.statusCode == 201) {
      print('Artikel berhasil ditambahkan');
    } else {
      throw Exception('Gagal menambahkan artikel');
    }
  }

  // Fungsi untuk upload artikel dengan gambar (optional)
  static Future<void> uploadArticleWithImage(String title, String content, File? image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/articles_with_image'));
    request.fields['title'] = title;
    request.fields['content'] = content;

    if (image != null) {
      var pic = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(pic);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Artikel dengan gambar berhasil diupload');
    } else {
      throw Exception('Gagal upload artikel dengan gambar');
    }
  }
}
