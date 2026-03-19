import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactItem extends StatelessWidget {

  final Contact contact;
  final VoidCallback onSms;
  final VoidCallback onSendWish; // thêm dòng này
  final Function(bool)? onSelect;

  const ContactItem({
    super.key,
    required this.contact,
    required this.onSms,
    required this.onSendWish, // thêm dòng này
    this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          )
        ],
      ),

      child: Column(
        children: [

          /// INFO
          Row(
            children: [
              Checkbox(
                value: contact.isSelected,
                onChanged: (value) {
                  if (onSelect != null) {
                    onSelect!(value!);
                  }
                },
              ),

              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=${contact.name.hashCode.abs() % 70 + 1}",
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    Text("Nhóm: ${contact.groupName}"),

                    const SizedBox(height: 4),

                    Text(
                      contact.greeted == 0
                          ? "📩 Chưa gửi lời chúc"
                          : "🧧 ${contact.sentWish}",
                      style: TextStyle(
                        color: contact.greeted == 0
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              /// GIFT BUTTON
              IconButton(
                icon: const Icon(
                  Icons.card_giftcard,
                  color: Colors.red,
                ),
                onPressed: onSendWish,
              ),
            ],
          ),

          const SizedBox(height: 10),

        ],
      ),
    );
  }
}