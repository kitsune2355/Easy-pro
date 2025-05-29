import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const EasyProApp());
}

class EasyProApp extends StatelessWidget {
  const EasyProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // เริ่มที่หน้า Login
    );
  }
}
