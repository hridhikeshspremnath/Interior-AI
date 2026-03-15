import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/room.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),

                  const Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email Field
                  _buildTextField("Email Address", false),

                  const SizedBox(height: 20),

                  // Password Field
                  _buildTextField("Password", true),

                  const SizedBox(height: 10),

                  const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  // Login Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(text: "Not a member? "),
                          TextSpan(
                            text: "Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Center(
                    child: Text(
                      "Or continue with",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(Icons.g_mobiledata, Colors.red),
                      const SizedBox(width: 20),
                      _socialButton(Icons.apple, Colors.black),
                      const SizedBox(width: 20),
                      _socialButton(Icons.facebook, Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField(String hint, bool isPassword) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static Widget _socialButton(IconData icon, Color color) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}