import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/services/article_service.dart';
import 'package:apk_apotek_unjaya/apk/models/article_model.dart';

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = ArticleService.fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load articles: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No articles available'),
            );
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
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
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl != null
                ? Image.network(
              'http://10.0.2.2:5000${article.imageUrl}',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            Text(
              article.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}
