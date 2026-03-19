import 'package:flutter/material.dart';

class WishModal extends StatelessWidget {

  final List<String> wishes;

  const WishModal({super.key, required this.wishes});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: wishes.length,
      itemBuilder: (context, index) {

        return ListTile(
          title: Text(wishes[index]),
        );

      },
    );
  }
}