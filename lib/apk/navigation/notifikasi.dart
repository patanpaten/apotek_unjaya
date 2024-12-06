import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: const Center(
        child: Text(
          "Halaman Notifikasi",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
