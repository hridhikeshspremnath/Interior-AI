import 'package:flutter/material.dart';

class ThemeCard extends StatelessWidget {

  final String title;
  final String image;

  const ThemeCard({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [

          /// Background Image
          Positioned.fill(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),

          /// Title
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );
  }
}