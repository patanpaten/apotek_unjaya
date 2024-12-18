import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembelian'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Halaman Pembelian',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
