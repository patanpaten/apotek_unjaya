import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  int _cartCount = 0;
  bool _isLoading = false;
  int? _currentUserId;


  List<Map<String, dynamic>> get cartItems => _cartItems;
  int get cartCount => _cartCount;
  bool get isLoading => _isLoading;


  static const String _baseUrl = 'http://10.0.2.2:5000';

  // Memuat keranjang dari server
  Future<void> loadCartFromServer(int userId) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/api/cart?user_id=$userId');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cartItems = List<Map<String, dynamic>>.from(data['cart'] ?? []);
        _cartCount = _cartItems.fold<int>(
          0,
              (sum, item) => sum + ((item['quantity'] ?? 0) as int),
        );
        print('Items dalam keranjang: $_cartItems');
        print('Jumlah item: $_cartCount');
      } else if (response.statusCode == 404) {
        print('Keranjang tidak ditemukan untuk user $userId');
        _cartItems = [];
        _cartCount = 0;
      } else {
        print('Gagal memuat keranjang: ${response.statusCode}');
        throw Exception('Gagal memuat keranjang');
      }
    } catch (e) {
      print('Error saat memuat keranjang: $e');
      throw Exception('Gagal memuat keranjang');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menghapus semua item di keranjang
  void clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    _cartItems = [];
    _cartCount = 0;
    notifyListeners();
  }

  // Menambahkan produk ke keranjang
  Future<void> addToCart(Map<String, dynamic> productData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      print("User ID tidak tersedia");
      return;
    }

    final productId = productData['id'] ?? -1;
    final quantity = productData['quantity'] ?? 1;

    if (productId == -1) {
      print("ID Produk tidak valid");
      return;
    }

    final url = Uri.parse('$_baseUrl/api/cart');
    final Map<String, dynamic> requestBody = {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Produk berhasil ditambahkan ke keranjang');
        await loadCartFromServer(userId);
      } else {
        print('Gagal menambahkan produk ke keranjang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat menambahkan produk ke keranjang: $e');
    }
  }

  // Menghapus produk dari keranjang
  Future<void> removeFromCart(int userId, int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = Uri.parse('$_baseUrl/api/cart?user_id=$userId&product_id=$productId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );

      if (response.statusCode == 200) {
        print('Produk berhasil dihapus dari keranjang');
        await loadCartFromServer(userId);
      } else {
        print('Gagal menghapus produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat menghapus produk: $e');
    }
  }

  // Menyimpan data keranjang ke server
  Future<void> saveCartToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      print("User ID tidak tersedia");
      return;
    }

    final url = Uri.parse('$_baseUrl/api/cart/save');

    final Map<String, dynamic> requestBody = {
      'user_id': userId,
      'cart_items': _cartItems,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Keranjang berhasil disimpan ke server');
      } else {
        print('Gagal menyimpan keranjang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat menyimpan keranjang: $e');
    }
  }

  Future<void> updateCartQuantity(int userId, int productId, int newQuantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$_baseUrl/api/cart/update_quantity');

    final Map<String, dynamic> requestBody = {
      'user_id': userId,
      'product_id': productId,
      'new_quantity': newQuantity,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Jumlah produk berhasil diperbarui');
        await loadCartFromServer(userId);
      } else {
        print('Gagal memperbarui jumlah produk: ${response.statusCode}');
        print('Respon: ${response.body}');
        if (response.statusCode == 404) {
          print('Item tidak ditemukan di keranjang. Pastikan produk sudah ada.');
        }
      }
    } catch (e) {
      print('Error saat memperbarui jumlah produk: $e');
    }
  }


  // Menghitung total harga
  double calculateTotalPrice() {
    return _cartItems.fold<double>(
      0.0,
          (sum, item) => sum + ((double.tryParse(item['product_price'] ?? '0') ?? 0) * (item['quantity'] ?? 0)),
    );
  }
}
