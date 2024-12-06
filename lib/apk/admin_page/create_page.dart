import 'package:flutter/material.dart';
import 'package:apk_apotek_unjaya/apk/admin_componen/add_produk.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman AddProdukPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProdukPage()),
                );
              },
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman AddArtikelPage
                // Anda dapat menambahkan logika untuk Add Artikel di sini
              },
              child: Text('Add Article'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
