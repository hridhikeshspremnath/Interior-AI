import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/room.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                // App Title
                const Text(
                  "INDAR",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                    color: Colors.white,
                    fontFamily: 'Serif',
                  ),
                ),

                const Spacer(),

                // Tagline
                const Text(
                  "Design your space.\nSee it instantly.\nBuy it effortlessly",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.6,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 40),

                // Get Started Button
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}