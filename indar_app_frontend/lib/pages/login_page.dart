import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'register_page.dart'; // ← add your register page import here

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.login(email: email, password: password);
      // StreamBuilder in main.dart handles navigation automatically

    } on AuthException catch (e) {
      debugPrint('AuthException: ${e.message}');
      _showError(e.message);
    } catch (e) {
      debugPrint('Login error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.signInWithGoogle();
    } catch (e) {
      debugPrint('Google sign in error: $e');
      _showError('Google sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/room.jpg', fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.75)),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 28,
                right: 28,
                top: MediaQuery.of(context).padding.top + 40,
                bottom: MediaQuery.of(context).padding.bottom + 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  const Text(
                    'Welcome.',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Sign in to continue.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white38,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Email field
                  _buildTextField(
                    hint: 'Email address',
                    controller: _emailController,
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 14),

                  // Password field
                  _buildPasswordField(),

                  const SizedBox(height: 14),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        final email = _emailController.text.trim();
                        if (email.isEmpty) {
                          _showError('Enter your email first.');
                          return;
                        }
                        try {
                          await AuthService.resetPassword(email);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset email sent.'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } catch (e) {
                          _showError('Failed to send reset email.');
                        }
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Login button
                  GestureDetector(
                    onTap: _isLoading ? null : _handleLogin,
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 0.5, color: Colors.white12),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: Colors.white30, fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 0.5, color: Colors.white12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _isLoading ? null : _handleGoogleSignIn,
                        child: _socialButton(Icons.g_mobiledata),
                      ),
                      const SizedBox(width: 14),
                      _socialButton(Icons.apple),
                      const SizedBox(width: 14),
                      _socialButton(Icons.facebook),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Register now — wired to RegisterPage
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                          children: [
                            const TextSpan(text: 'Not a member? '),
                            TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required bool isPassword,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          suffixIcon: GestureDetector(
            onTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white30,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _socialButton(IconData icon) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Icon(icon, color: Colors.white70, size: 26),
    );
  }
}
