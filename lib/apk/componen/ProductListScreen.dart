class ProductListScreen extends StatelessWidget {
  final String category;
  const ProductListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Ambil data produk untuk kategori yang dipilih
    final List<Map<String, String>> products = categoryProducts[category]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Products - $category'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(product['name']!),
              subtitle: Text('Price: ${product['price']}'),
              onTap: () {
                // Navigasi ke halaman detail produk jika ada
              },
            ),
          );
        },
      ),
    );
  }
}
