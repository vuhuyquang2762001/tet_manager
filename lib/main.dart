import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TetManagerApp());
}

class TetManagerApp extends StatelessWidget {
  const TetManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chúc Tết 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}