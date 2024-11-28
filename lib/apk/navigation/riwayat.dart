import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat")),
      body: const Center(
        child: Text("Halaman Riwayat"),
      ),
    );
  }
}
