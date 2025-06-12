import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:easy_pro/controllers/login_controller.dart'; // Assuming this exists
import 'package:easy_pro/screens/main_screen.dart'; // Assuming this exists
import 'package:flutter/material.dart';

// Define a sophisticated and professional color palette
class AppColors {
  static const Color primaryDeepBlue = Color(0xFF0C3B5E); // A deep, rich blue
  static const Color primaryLightBlue = Color(
    0xFF1E639A,
  ); // A slightly lighter primary for accents/gradients
  static const Color backgroundLight = Color(
    0xFFE8F1F2,
  ); // Very light blue-grey for background
  static const Color cardBackground =
      Colors.white; // Pure white for card surfaces
  static const Color textDark = Color(0xFF333333); // Dark text for readability
  static const Color textMedium = Color(
    0xFF707070,
  ); // Medium grey for hints and secondary text
  static const Color dividerLight = Color(
    0xFFE0E0E0,
  ); // Light grey for borders/dividers
  static const Color errorRed = Color(0xFFD32F2F); // Standard error red
}

// Helper function for input decoration - refined for professionalism
InputDecoration _inputDecoration(
  String hint, {
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textMedium, fontSize: 16),
    fillColor: AppColors.cardBackground, // Always white inside the card
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // Slightly rounded for softness
      borderSide: const BorderSide(
        color: AppColors.dividerLight,
        width: 1,
      ), // Light, subtle border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.dividerLight, // Subtle border when enabled
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.primaryLightBlue, // Primary accent color when focused
        width: 2, // Thicker border on focus for clear indication
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
    ),
  );
}

// Reusable widget for the logo
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_full.png', // Ensure this path is correct and the logo is high-res
      height: 160, // Optimized height for a refined look
      fit: BoxFit.contain,
    );
  }
}

// Reusable widget for username field
class _UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: const TextStyle(color: AppColors.textDark, fontSize: 16),
      decoration: _inputDecoration(
        "ชื่อผู้ใช้",
        prefixIcon: const Icon(
          Icons.person_outline,
          color: AppColors.textMedium,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อผู้ใช้';
        }
        return null;
      },
    );
  }
}

// Reusable widget for password field
class _PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: const TextStyle(color: AppColors.textDark, fontSize: 16),
      decoration: _inputDecoration(
        "รหัสผ่าน",
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMedium),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textMedium,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        }
        return null;
      },
    );
  }
}

// Reusable widget for login button - refined for elegance
class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _LoginButton({required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54, // Slightly taller for presence
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.primaryDeepBlue, // Deep blue for primary action
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // Matching input field corners
          ),
          elevation: 8, // More prominent, but diffused shadow
          shadowColor: AppColors.primaryDeepBlue.withOpacity(
            0.3,
          ), // Soft shadow color
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ) // Thinner progress indicator
            : const Text("เข้าสู่ระบบ"),
      ),
    );
  }
}

// Modernized background with a subtle gradient (replacing distinct shapes)
class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white,
            Color(0xFFC5E0FF),
            Color(0xFF68A6EC),
          ],
        ),
      ),
    );
  }
}

// MD5 hashing utility (kept as is)
String generateMd5(String input) {
  String result = input;
  for (int i = 0; i < 3; i++) {
    result = md5.convert(utf8.encode(result)).toString();
  }
  return result;
}

// Main Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final hashedPassword = generateMd5(passwordController.text.trim());

      // Simulate API call delay for demonstration
      await Future.delayed(const Duration(seconds: 2));

      // Replace with actual LoginController.login call
      bool success = await LoginController.login(
        usernameController.text.trim(),
        hashedPassword,
      );

      setState(() => isLoading = false);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(20),
            duration: const Duration(seconds: 3), // Show for a bit longer
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent to show gradient
      body: Stack(
        children: [
          const _BackgroundGradient(), // Subtle gradient background
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                ), // Slightly more horizontal padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center content horizontally
                  children: [
                    // Only show logo if keyboard is not open
                    if (!isKeyboardOpen) ...[
                      const _Logo(),
                      const SizedBox(height: 30), // Ample space below logo
                    ],
                    Card(
                      // Enhanced Card for the login form
                      elevation: 12, // More pronounced, but soft shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ), // Softer corners for the card
                      ),
                      color: AppColors.cardBackground, // White card background
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          32.0,
                        ), // Generous padding inside the card
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _UsernameField(controller: usernameController),
                              const SizedBox(height: 20),
                              _PasswordField(controller: passwordController),
                              const SizedBox(height: 30),
                              _LoginButton(
                                onPressed: _handleLogin,
                                isLoading: isLoading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isKeyboardOpen ? 20 : 0),
                  ],
                ),
              ),
            ),
          ),
          // Company name at the bottom
          if (!isKeyboardOpen)
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Text(
                'PROACTIVE MANAGEMENT CO,.LTD',
                style: TextStyle(
                  color: Colors.white, // Softer, more integrated
                  fontSize: 11, // Slightly larger
                  letterSpacing: 1.0, // Increased for distinctness
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center, // Centered for balance
              ),
            ),
        ],
      ),
    );
  }
}
