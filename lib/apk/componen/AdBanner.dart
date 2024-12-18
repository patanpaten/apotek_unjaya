import 'package:flutter/material.dart';

class AdBanner extends StatelessWidget {
  final String adImage;
  final String adLink;

  const AdBanner({super.key, required this.adImage, required this.adLink});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tindakan ketika iklan ditekan, misalnya membuka link atau halaman baru
        print('Ad clicked: $adLink');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100, // Ukuran iklan
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(adImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
