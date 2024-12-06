import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000'; // Ganti dengan URL backend Anda

  // Fungsi untuk registrasi user
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String confirmPassword) async {
    final url = Uri.parse('$_baseUrl/api/register'); // Endpoint register

    // Membuat body request
    final Map<String, String> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      // Mengirim POST request ke API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Mengecek apakah request berhasil
      if (response.statusCode == 201) {
        // Jika berhasil, kembalikan response sebagai map
        return {'message': 'Registration successful'};
      } else {
        // Jika gagal, kembalikan error message
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return {'error': responseBody['error'] ?? 'Unknown error'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to server'};
    }
  }

  // Fungsi untuk login user
  // Fungsi untuk login user (termasuk admin)
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/login'); // Endpoint login

    // Membuat body request
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      // Mengirim POST request ke API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Mengecek apakah request berhasil
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Tambahkan logika untuk memisahkan admin dan user biasa
        if (responseBody['is_admin'] == true) {
          return {
            'message': 'Welcome Admin!',
            'is_admin': true,
            'user': responseBody['user'], // Informasi admin
          };
        } else {
          return {
            'message': responseBody['message'],
            'is_admin': false,
            'user': responseBody['user'], // Informasi pengguna biasa
          };
        }
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return {'error': responseBody['error'] ?? 'Invalid email or password'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to server'};
    }
  }
}
