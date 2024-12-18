import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/admin_page/create_page.dart';// Pastikan CreatePage dipisahkan menjadi file lain

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Dashboard Admin',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}