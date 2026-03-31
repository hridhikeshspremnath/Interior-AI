import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

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

              const Text(
                "Profile",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Username"),
                      Text("Email id"),
                      Text("Phone no"),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 25),

              _menuItem("Transaction History"),
              _menuItem("Privacy Policy"),
              _menuItem("FAQ"),
              _menuItem("Setting"),
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

  static Widget _menuItem(String title) {
    return Column(
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
    );
  }
}
