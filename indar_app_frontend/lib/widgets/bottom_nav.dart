import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/add_photo_page.dart';
import '../pages/cart_page.dart';
import '../pages/profile_page.dart';

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
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          },
          child: const Icon(Icons.home, color: Colors.white),
        ),

        /// ADD PHOTO
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPhotoPage(),
              ),
            );
          },
          child: const Icon(Icons.add_circle_outline, color: Colors.white),
        ),

        /// CART (STAR BUTTON)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartPage(),
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
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          child: const Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    ),
  );
}