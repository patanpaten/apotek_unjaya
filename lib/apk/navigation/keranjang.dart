import 'package:flutter/material.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: const Center(
        child: Text(
          "Halaman Keranjang",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
