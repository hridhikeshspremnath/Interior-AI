import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    if (password != confirm) {
      _showError('Passwords do not match.');
      return;
    }

    if (password.length < 8) {
      _showError('Password must be at least 8 characters.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.register(email: email, password: password);

      // After register — update name in FastAPI
      await AuthService.updateName(name);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Please check your email to confirm.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Go back to login
        Navigator.pop(context);
      }

    } on AuthException catch (e) {
      debugPrint('AuthException: ${e.message}');
      _showError(e.message);
    } catch (e) {
      debugPrint('Register error: $e');
      _showError('Something went wrong. Please try again.');
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
            // Same background as login
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
                    'Create account.',
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
                    'Sign up to get started.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white38,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Name
                  _buildTextField(
                    hint: 'Full name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 14),

                  // Email
                  _buildTextField(
                    hint: 'Email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 14),

                  // Password
                  _buildPasswordField(
                    hint: 'Password',
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    onToggle: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Confirm password
                  _buildPasswordField(
                    hint: 'Confirm password',
                    controller: _confirmController,
                    obscure: _obscureConfirm,
                    onToggle: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Register button
                  GestureDetector(
                    onTap: _isLoading ? null : _handleRegister,
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
                                'Create Account',
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

                  const SizedBox(height: 40),

                  // Already have account
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                          children: [
                            const TextSpan(text: 'Already a member? '),
                            TextSpan(
                              text: 'Sign in',
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

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscure
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
}
