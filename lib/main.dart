import 'package:flutter/material.dart';
import 'pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty 2gether',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFD4826A),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}