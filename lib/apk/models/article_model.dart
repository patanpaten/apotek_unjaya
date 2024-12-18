class Article {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;

  // Constructor
  Article({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  // Fungsi untuk mengubah data JSON ke objek Article
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,               // Pastikan konversi tipe yang benar
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,  // Gunakan null-aware jika image_url bisa null
    );
  }

  // Fungsi untuk mengubah objek Article menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,  // Gunakan 'image_url' sesuai dengan respons API
    };
  }
}
