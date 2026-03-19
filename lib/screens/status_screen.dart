import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Thống kê")),

      body: const Center(
        child: Text("Thống kê lời chúc"),
      ),
    );
  }
}