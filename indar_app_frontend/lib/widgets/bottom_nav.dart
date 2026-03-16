import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/cart_page.dart';
import '../pages/add_photo_page.dart';

Widget buildBottomNav(BuildContext context) {
  return Container(
    height: 70,
    margin: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(35),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        /// HOME
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
          child: const Icon(Icons.home, color: Colors.white),
        ),

        /// ADD PHOTO — goes to HomePage where user picks a template first
        /// Template → TemplatePage → AddPhotoPage(themeName) is the correct flow
        GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPhotoPage(), // ← no themeName needed
      ),
    );
  },
  child: const Icon(Icons.add_circle_outline, color: Colors.white),
),

        /// CART
       /// CART
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartPage(), // no bundle — shows empty state
      ),
    );
  },
  child: const Icon(Icons.star_border, color: Colors.white),
),

        /// PROFILE
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          child: const Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    ),
  );
}