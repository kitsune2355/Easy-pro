import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:easy_pro/controllers/login_controller.dart';
import 'package:easy_pro/screens/home_screen.dart';
import 'package:flutter/material.dart';

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo_pro.png', height: 120);
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "EasyPro",
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Color(0xFF006B9F),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration("Username"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อผู้ใช้';
        }
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: _inputDecoration("Password"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        }
        return null;
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006B9F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: const Text("Login", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Color(0xFF006B9F), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Color(0xFF9FD7F3), width: 2),
    ),
  );
}

class _BackgroundShapes extends StatelessWidget {
  const _BackgroundShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildArrowRight(context)]);
  }

  Widget _buildArrowRight(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Positioned(
          top: height * 0.2,
          left: width * 0.1,
          child: Transform.rotate(
            angle: 0.0,
            child: CustomPaint(
              size: Size(width * 1, height * 1),
              painter: TrianglePainter(),
            ),
          ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.width / 10)
      ..lineTo(size.width * 2, size.height / 2)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String generateMd5(String input) {
  String result = input;
  for (int i = 0; i < 3; i++) {
    result = md5.convert(utf8.encode(result)).toString();
  }
  return result;
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;

  void _handleLogin() async {
  if (_formKey.currentState!.validate()) {
    setState(() => isLoading = true);

    final hashedPassword = generateMd5(password.text.trim());

    bool success = await LoginController.login(username.text.trim(), hashedPassword);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006B9F),
      body: Stack(
        children: [
          const _BackgroundShapes(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _Logo(),
                      const SizedBox(height: 20),
                      const _AppTitle(),
                      const SizedBox(height: 40),
                      _UsernameField(controller: username),
                      const SizedBox(height: 20),
                      _PasswordField(controller: password),
                      const SizedBox(height: 50),
                      isLoading
                          ? const CircularProgressIndicator()
                          : _LoginButton(onPressed: _handleLogin),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
