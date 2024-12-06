// article_section.dart
import 'package:flutter/material.dart';

class ArticleSection extends StatelessWidget {
  final List<Map<String, String>> articles;

  const ArticleSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Artikel Kesehatan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              child: ListTile(
                title: Text(article["title"]!),
                subtitle: Text(article["content"]!),
              ),
            );
          },
        ),
      ],
    );
  }
}
