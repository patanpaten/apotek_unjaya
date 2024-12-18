import 'package:flutter/material.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_placeholder.png'), // Gambar profil
            ),
            const SizedBox(height: 16),
            const Text(
              "Nama Pengguna",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Email: user@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Pengaturan Akun"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Tambahkan aksi jika diperlukan
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Keluar"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Tambahkan aksi logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
