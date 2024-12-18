import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apk_apotek_unjaya/apk/models/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apk_apotek_unjaya/apk/api_service.dart';
import 'package:apk_apotek_unjaya/apk/componen/CheckoutPage.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int? userId;
  List<int> selectedProductIds = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await ApiService.getUserId();
    setState(() {
      userId = id;
    });
  }

  void _toggleSelection(int productId) {
    setState(() {
      if (selectedProductIds.contains(productId)) {
        selectedProductIds.remove(productId);
      } else {
        selectedProductIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang Belanja'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.cartCount <= 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${cartProvider.cartCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProvider.cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Keranjang belanja kosong!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartProvider.cartItems[index];

              final imageUrl = item["image_url"] ?? '';
              final productName = item["product_name"] ?? "Produk";
              final productPrice = double.tryParse(item["product_price"]?.toString() ?? '0') ?? 0.0;
              final quantity = item["quantity"] ?? 0;

              final fullImageUrl = 'http://10.0.2.2:5000$imageUrl';

              return Dismissible(
                key: Key(item["product_id"].toString()), // Unique key for each item
                direction: DismissDirection.endToStart, // Swipe from right to left
                onDismissed: (direction) {
                  // Remove product from cart when swiped
                  cartProvider.removeFromCart(item["user_id"] ?? 0, item["product_id"] ?? 0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item["product_name"]} telah dihapus dari keranjang")),
                  );
                },
                background: Container(
                  color: Colors.red, // Red background for swipe-to-delete
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Checkbox for product selection
                          GestureDetector(
                            onTap: () {
                              _toggleSelection(item["product_id"]);
                            },
                            child: Container(
                              width: 24, // Smaller width for the checkbox
                              height: 24, // Smaller height for the checkbox
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey, width: 2),
                                color: selectedProductIds.contains(item["product_id"]) ? Colors.blue : Colors.transparent,
                              ),
                              child: selectedProductIds.contains(item["product_id"])
                                  ? const Icon(Icons.check, size: 16, color: Colors.white) // Smaller check icon
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12), // Space between checkbox and image
                          // Product Image
                          Image.network(
                            fullImageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 70);
                            },
                          ),
                          const SizedBox(width: 12), // Space between image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Quantity and Price Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // No background for "-" button
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            if (quantity > 1) {
                                              cartProvider.updateCartQuantity(userId!, item["product_id"], quantity - 1);
                                            } else {
                                              cartProvider.removeFromCart(item["user_id"] ?? 0, item["product_id"] ?? 0);
                                            }
                                          },
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        // Smaller background for "+" button
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.teal, // Background color for "+"
                                            shape: BoxShape.circle, // Make it round
                                          ),
                                          padding: const EdgeInsets.all(2), // Adjust padding to fit the "+" icon closely
                                          child: IconButton(
                                            icon: const Icon(Icons.add, color: Colors.white),
                                            padding: EdgeInsets.zero, // Remove any extra padding around the icon
                                            iconSize: 20, // Adjust the icon size to fit the button appropriately
                                            onPressed: () {
                                              final updatedQuantity = quantity + 1;
                                              if (userId != null) {
                                                cartProvider.updateCartQuantity(userId!, item["product_id"], updatedQuantity);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Product Price
                                    Text(
                                      "Rp ${productPrice.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return const SizedBox.shrink();
          }

          final totalSelectedPrice = cartProvider.cartItems.where((item) => selectedProductIds.contains(item["product_id"])).fold(0.0, (total, item) {
            final productPrice = double.tryParse(item["product_price"]?.toString() ?? '0') ?? 0.0;
            final quantity = item["quantity"] ?? 0;
            return total + (productPrice * quantity);
          });

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rp ${totalSelectedPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedProductIds.isNotEmpty) {
                      // Filter produk yang dipilih
                      final selectedProducts = cartProvider.cartItems
                          .where((item) => selectedProductIds.contains(item["product_id"]))
                          .toList();

                      // Pastikan data selectedProducts dikirim ke CheckoutPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(selectedProducts: selectedProducts),
                        ),
                      );
                    } else {
                      print("Tidak ada produk yang dipilih untuk checkout.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 52.0),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Check Out'),
                )


              ],
            ),
          );
        },
      ),
    );
  }
}
