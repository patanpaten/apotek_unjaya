class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;
  final String? imageUrl; // Menambahkan imageUrl untuk gambar produk

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: json['stock'],
      description: json['description'],
      imageUrl: json['image_url'], // Mengambil image_url dari JSON
    );
  }
}
