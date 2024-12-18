import 'package:flutter/material.dart';

class PromotionSection extends StatefulWidget {
  @override
  _PromotionSectionState createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, String>> promotions = [
    {'title': 'Diskon Besar', 'description': 'Diskon hingga 50% untuk semua produk'},
    {'title': 'Gratis Ongkir', 'description': 'Dapatkan ongkir gratis untuk pembelian di atas \$50'},
  ];

  void _addPromotion() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      setState(() {
        promotions.add({
          'title': _titleController.text,
          'description': _descriptionController.text,
        });
        _titleController.clear();
        _descriptionController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promosi berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap lengkapi semua kolom')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promosi'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Promosi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi Promosi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPromotion,
              child: const Text('Tambah Promosi'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: promotions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(promotions[index]['title']!),
                      subtitle: Text(promotions[index]['description']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
