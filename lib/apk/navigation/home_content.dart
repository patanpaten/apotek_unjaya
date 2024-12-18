import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/componen/product_section.dart'; // Komponen Produk
import 'package:apk_apotek_unjaya/apk/services/article_service.dart'; // Import ArticleService
import 'package:apk_apotek_unjaya/apk/models/article_model.dart'; // Import Article Model
import 'package:apk_apotek_unjaya/apk/componen/article_list_screen.dart'; // Halaman untuk artikel lengkap
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:image_picker/image_picker.dart'; // Import ImagePicker
import 'dart:io'; // Untuk File (gambar)

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<Article>> _articles;
  File? _imageFile; // Variabel untuk menyimpan gambar profil
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _articles = ArticleService.fetchArticles(); // Ambil artikel dari service
  }

  // Fungsi untuk mengambil username dari SharedPreferences
  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final token = prefs.getString('token');

    // Cetak username dan token ke konsol untuk debugging
    print('Username: $username');
    print('Token: $token');

    return username;
  }

  // Fungsi untuk mengambil gambar profil dari SharedPreferences
  Future<File?> _getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      return File(imagePath); // Mengembalikan file gambar jika ada
    }
    return null;
  }

  // Fungsi untuk mengganti gambar profil
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Menyimpan file gambar
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path); // Simpan path gambar di SharedPreferences
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Menampilkan Nama Pengguna dan Foto Profil
            FutureBuilder<String?>(
              future: _getUsername(), // Ambil username dari SharedPreferences
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No username found'));
                } else {
                  return Row(
                    children: [
                      // Menampilkan foto profil jika ada
                      FutureBuilder<File?>(
                        future: _getProfileImage(),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (imageSnapshot.hasError) {
                            return const Icon(Icons.error);
                          } else {
                            return GestureDetector(
                              onTap: _pickImage, // Menambahkan fungsi pilih gambar saat diklik
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: imageSnapshot.hasData
                                    ? FileImage(imageSnapshot.data!)
                                    : const AssetImage('assets/images/default-profile.png') as ImageProvider,
                                child: imageSnapshot.data == null ? const Icon(Icons.camera_alt) : null, // Menampilkan ikon kamera jika belum ada foto
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      // Menampilkan username
                      Text(
                        'Halo, ${snapshot.data}!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Selamat datang kembali di MediSync!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Kirim data produk yang sesuai ke ProductSection
            ProductSection(products: [
              {'name': 'Paracetamol', 'price': '5000'},
            ]),
            const SizedBox(height: 20),
            // Menampilkan Artikel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Artikel Terkini',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticleListScreen()),
                    );
                  },
                  child: Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tampilkan artikel terbatas (3 atau 4 artikel pertama)
            FutureBuilder<List<Article>>(
              future: _articles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No articles available'));
                }

                final articles = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true, // Tidak perlu scroll
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: articles.length > 4 ? 4 : articles.length, // Tampilkan maksimal 4 artikel
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: article.imageUrl != null
                            ? Image.network(
                          'http://10.0.2.2:5000${article.imageUrl}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.article),
                        title: Text(article.title),
                        subtitle: Text(
                          article.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
