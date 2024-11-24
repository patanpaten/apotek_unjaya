import 'package:flutter/material.dart';

class FluBatukAlergi extends StatelessWidget {
  const FluBatukAlergi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          "Obat Flu Batuk Alergi",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const Center(
        child: Text("Obat Flu Batuk Alergi"),
      ),
    );
  }
}
