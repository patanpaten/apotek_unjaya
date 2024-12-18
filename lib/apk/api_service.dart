import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apk_apotek_unjaya/apk/models/cart_provider.dart';
import 'package:apk_apotek_unjaya/apk/Login.dart';
import 'package:provider/provider.dart';


class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000'; // URL backend Anda

  // Fungsi untuk registrasi user
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String confirmPassword) async {
    final url = Uri.parse('$_baseUrl/api/register'); // Endpoint register

    final Map<String, String> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        return {'message': 'Registration successful'};
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return {'error': responseBody['error'] ?? 'Unknown error'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to server'};
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      BuildContext context, String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/login'); // Endpoint login

    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Simpan informasi pengguna
        await prefs.setInt('user_id', responseBody['user']['id']); // ID pengguna
        await prefs.setString('username', responseBody['user']['name']);
        await prefs.setString('email', responseBody['user']['email']);
        await prefs.setString('token', responseBody['token']); // Simpan token

        // Simpan tanda admin (jika ada)
        if (responseBody['is_admin'] == true) {
          await prefs.setBool('is_admin', true); // Tanda admin
          print('Admin login');
        } else {
          await prefs.setBool('is_admin', false); // Tanda user biasa
          print('User login');
        }

        // Ambil user_id dari response dan muat keranjang dari server
        int userId = responseBody['user']['id'];

        // Menggunakan Provider untuk memanggil loadCartFromServer
        Provider.of<CartProvider>(context, listen: false).loadCartFromServer(userId);

        return {
          'message': responseBody['message'],
          'is_admin': responseBody['is_admin'],
          'user': responseBody['user'],
        };
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return {'error': responseBody['error'] ?? 'Invalid email or password'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to server'};
    }
  }

  // Fungsi untuk mendapatkan token dari SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Mengembalikan token
  }


  static Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Provider.of<CartProvider>(context, listen: false).clearCart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Halaman login
    );
    print('User logged out, cart data preserved on server.');
  }


  // Fungsi untuk mendapatkan username dari SharedPreferences
  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Fungsi untuk mendapatkan ID user dari SharedPreferences
  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // Fungsi untuk memeriksa apakah user adalah admin
  static Future<bool> isAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_admin') ?? false;
  }
}
