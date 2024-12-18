import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryButton({super.key, required this.category, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Menampilkan gambar kategori
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          // Menampilkan nama kategori
          Text(
            category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
