import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apk_apotek_unjaya/apk/models/cart_provider.dart';
import 'package:apk_apotek_unjaya/apk/navigation/shopping_cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.teal,
        actions: [
          // Ikon notifikasi tetap terpisah
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifikasi');
            },
          ),

          // Ikon shopping cart dengan badge merah
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartPage(),
                    ),
                  );
                },
              ),
              if (cartProvider.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartProvider.cartCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.network(
              'http://10.0.2.2:5000${product["image_url"]}',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama produk
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Kontrol jumlah (_ 1 +) dan harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            icon: const Icon(Icons.remove),
                            color: Colors.teal,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "$quantity",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Rp ${product['price']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rating bintang lima
                Row(
                  children: List.generate(5, (index) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),

                const SizedBox(height: 16),
                // Deskripsi produk
                Text(
                  product['description'] ?? 'Deskripsi tidak tersedia.',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Add to Cart
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  cartProvider.addToCart({
                    'id': product['id'],
                    'name': product['name'],
                    'price': product['price'],
                    'quantity': quantity,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product['name']} ditambahkan ke keranjang."),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart, color: Color(0xFF199A8E)),
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8F3F1),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Tombol Buy Now
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Pembelian ${product['name']} sedang diproses."),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
