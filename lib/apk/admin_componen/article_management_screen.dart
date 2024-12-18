import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/models/article_model.dart';
import 'package:apk_apotek_unjaya/apk/services/article_service.dart';
import 'package:apk_apotek_unjaya/apk/admin_componen/AddArticleScreen.dart';
import 'package:apk_apotek_unjaya/apk/admin_componen/EditArticleScreen.dart';

class ArticleManagementScreen extends StatefulWidget {
  @override
  _ArticleManagementScreenState createState() =>
      _ArticleManagementScreenState();
}

class _ArticleManagementScreenState extends State<ArticleManagementScreen> {
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = ArticleService.fetchArticles(); // Mengambil artikel saat pertama kali
  }

  // Fungsi untuk menambah artikel
  void _addArticle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddArticleScreen()),
    ).then((_) {
      setState(() {
        _articles = ArticleService.fetchArticles(); // Refresh daftar artikel setelah menambah artikel
      });
    });
  }

  // Fungsi untuk mengedit artikel
  void _editArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditArticleScreen(article: article),
      ),
    ).then((_) {
      setState(() {
        _articles = ArticleService.fetchArticles(); // Refresh daftar artikel setelah edit
      });
    });
  }

  // Fungsi untuk menghapus artikel
  void _deleteArticle(int id) async {
    try {
      await ArticleService.deleteArticle(id);  // Panggil API untuk menghapus artikel
      setState(() {
        _articles = ArticleService.fetchArticles(); // Refresh artikel setelah dihapus
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artikel berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus artikel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Articles'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addArticle,
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text('Content: ${article.content}'),
                  isThreeLine: true,
                  leading: article.imageUrl != null && article.imageUrl!.isNotEmpty
                      ? SizedBox(
                    width: 50,  // Ukuran gambar yang lebih kecil
                    height: 50,
                    child: Image.network(
                      'http://10.0.2.2:5000${article.imageUrl}',  // Gunakan URL gambar yang benar
                      fit: BoxFit.cover,  // Menyesuaikan gambar dengan ukuran
                    ),
                  )
                      : Icon(Icons.image),  // Gambar default jika tidak ada URL
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editArticle(article),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteArticle(article.id),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No articles found'));
          }
        },
      ),
    );
  }
}
