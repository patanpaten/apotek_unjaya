import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: 5, // Jumlah dummy data
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.receipt, color: Colors.teal),
              title: Text("Pesanan #${index + 1}"),
              subtitle: const Text("Status: Selesai"),
              trailing: const Text(
                "Rp 100.000",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Aksi jika item diklik
              },
            ),
          );
        },
      ),
    );
  }
}
