import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:easy_pro/controllers/login_controller.dart'; // Assuming this exists
import 'package:easy_pro/screens/main_screen.dart'; // Assuming this exists
import 'package:flutter/material.dart';

// Helper function for input decoration
InputDecoration _inputDecoration(String hint, {Widget? prefixIcon}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // Softer rounded corners
      borderSide: BorderSide.none, // No border by default, rely on fill color
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1), // Subtle border when enabled
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF006B9F), width: 2), // Primary color border when focused
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2), // Red border for errors
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2), // Darker red when focused on error
    ),
  );
}

// Reusable widget for the logo
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/Easy_Prologo_White.png', height: 150); // Slightly larger logo
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
      decoration: _inputDecoration(
        "ชื่อผู้ใช้",
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFB0B0B0)),
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
      decoration: _inputDecoration(
        "รหัสผ่าน",
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB0B0B0)),
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFFB0B0B0),
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

// Reusable widget for login button
class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _LoginButton({required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56, // Slightly taller button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 15, 77, 119),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Softer rounded corners
          ),
          elevation: 5, // Add a subtle shadow
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "เข้าสู่ระบบ", // Changed text to Thai for consistency
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

// Modernized background shapes
class _BackgroundShapes extends StatelessWidget {
  const _BackgroundShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Large, subtle circle in the bottom left
        Positioned(
          bottom: -MediaQuery.of(context).size.width * 0.3,
          left: -MediaQuery.of(context).size.width * 0.3,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        // Smaller, subtle circle in the top right
        Positioned(
          top: -MediaQuery.of(context).size.width * 0.1,
          right: -MediaQuery.of(context).size.width * 0.1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        // Abstract wave/blob shape (more complex, using CustomPainter)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.3),
            painter: WavePainter(color: Colors.white.withOpacity(0.08)),
          ),
        ),
      ],
    );
  }
}

// Custom painter for a subtle wave/blob shape
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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

      bool success = await LoginController.login(
        usernameController.text.trim(),
        hashedPassword,
      );

      setState(() => isLoading = false);

      if (success) {
        // Navigate to MainScreen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // Show a more prominent error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating, // Makes it float above content
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.98),
      body: Stack(
        children: [
          const _BackgroundShapes(), // Modernized background
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Only show logo if keyboard is not open
                      if (!isKeyboardOpen) ...[
                        const _Logo(),
                        const SizedBox(height: 60), // Increased space below logo
                      ],
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _UsernameField(controller: usernameController),
                            const SizedBox(height: 20),
                            _PasswordField(controller: passwordController),
                            const SizedBox(height: 30), // Adjusted spacing
                            _LoginButton(
                              onPressed: _handleLogin,
                              isLoading: isLoading,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: isKeyboardOpen ? 20 : 0), // Dynamic spacing for keyboard
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Company name at the bottom right
          if (!isKeyboardOpen)
            Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                'PROACTIVE MANAGEMENT CO,.LTD',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6), // Softer opacity
                  fontSize: 8, // Slightly larger font
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
