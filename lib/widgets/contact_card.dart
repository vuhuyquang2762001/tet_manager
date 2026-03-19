import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'contact_item.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});



void _smsContact() {
  print("SMS ${contact.phone}");
}


  void _sendWish() {
    print("Send wish to ${contact.name}");
  }

  @override
  Widget build(BuildContext context) {
    return ContactItem(
      contact: contact,
      onSms: _smsContact,
      onSendWish: _sendWish, // thêm dòng này
    );
  }
}