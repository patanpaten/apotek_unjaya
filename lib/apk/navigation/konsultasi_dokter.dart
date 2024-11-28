import 'package:flutter/material.dart';

class KonsultasiDokter extends StatelessWidget {
  const KonsultasiDokter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konsultasi Dokter")),
      body: const Center(
        child: Text("Halaman Konsultasi Dokter"),
      ),
    );
  }
}
