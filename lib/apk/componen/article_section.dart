import 'package:flutter/material.dart';

class ArticleSection extends StatelessWidget {
  final List<Map<String, String>> articles; // Daftar artikel yang diterima

  const ArticleSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Artikel Terbaru',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Menampilkan artikel menggunakan ListView
        ListView.builder(
          shrinkWrap: true, // Untuk membuat listview tidak perlu scroll
          physics: const NeverScrollableScrollPhysics(), // Menghindari scrolling pada listview
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(articles[index]['title']!),
                subtitle: Text(
                  articles[index]['content']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Agar deskripsi tidak meluber
                ),
                onTap: () {
                  // Tindakan saat artikel diklik (misalnya membuka artikel lengkap)
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
