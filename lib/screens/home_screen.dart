import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หน้าหลัก')),
      body: const Center(
        child: Text('ยินดีต้อนรับเข้าสู่ EasyPro!'),
      ),
    );
  }
}
