import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'profile_details_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      bottomNavigationBar: buildBottomNav(context),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              const Text(
                "PROFILE",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Your Board",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  _boardImage("assets/images/room.jpg"),
                  const SizedBox(width: 15),
                  _boardImage("assets/images/room.jpg"),

                ],
              ),

              const SizedBox(height: 30),

              _menuItem(
                context,
                "Profile",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileDetailsPage(),
                    ),
                  );
                },
              ),

              _menuItem(context, "Transaction History"),
              _menuItem(context, "FAQ"),
              _menuItem(context, "Setting"),
              _menuItem(context, "Privacy Policy"),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _boardImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        image,
        height: 90,
        width: 130,
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget _menuItem(BuildContext context, String title,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              const Icon(Icons.arrow_forward_ios, size: 16)
            ],
          ),

          const SizedBox(height: 10),

          const Divider(thickness: 1),

        ],
      ),
    );
  }
}