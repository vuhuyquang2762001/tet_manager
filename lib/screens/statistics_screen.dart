import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/statistics_widget.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Contact> contacts;

  const StatisticsScreen({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFE),
      appBar: AppBar(
        title: const Text("Thống Kê Chúc Tết"),
        backgroundColor: Colors.red,
      ),
      body: StatisticsWidget(
        contacts: contacts,
      ),
    );
  }
}