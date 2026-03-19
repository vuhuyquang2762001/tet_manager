import 'package:flutter/material.dart';
import 'package:tet_manager/screens/statistics_screen.dart';
import '../widgets/contact_item.dart';
import '../models/contact.dart';
import 'add_contact_screen.dart';
import '../widgets/wish_template_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedWish = "";
  int currentIndex = 0;

  List<Contact> contacts = [];



  void addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void sendSelectedWish() {

    if (selectedWish.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hãy chọn lời chúc trước"),
        ),
      );

      return;
    }

    setState(() {

      for (var contact in contacts) {

        if (contact.isSelected) {

          contact.greeted = 1;
          contact.sentWish = selectedWish;

          print("Send SMS to ${contact.phone}");
          print("Message: $selectedWish");

        }

      }
      currentIndex = 0;
    });

  }

  void sendWish(Contact contact) {

    if (selectedWish.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hãy chọn mẫu lời chúc trước"),
        ),
      );

      return;
    }

    setState(() {
      contact.greeted = 1;
      contact.sentWish = selectedWish;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã gửi lời chúc"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [

      /// PAGE 1: DANH BẠ
      Column(
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),

            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [

                    Icon(Icons.search, size: 28),

                    Text(
                      "CHÚC TẾT 2026",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Icon(Icons.settings)
                  ],
                ),

                const SizedBox(height: 15),

                /// SEARCH BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Tìm kiếm tên, số điện thoại hoặc nhóm...",
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [

                ElevatedButton.icon(
                  onPressed: sendSelectedWish,
                  icon: const Icon(Icons.send),
                  label: const Text("Gửi đã chọn"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: () {

                    setState(() {

                      for (var c in contacts) {
                        c.isSelected = !c.isSelected;
                      }

                    });

                  },
                  icon: const Icon(Icons.select_all),
                  label: const Text("Chọn tất cả"),
                ),

              ],
            ),
          ),

          const SizedBox(height: 10),

          /// CONTACT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: contacts.length,

              itemBuilder: (context, index) {

                final contact = contacts[index];

                return ContactItem(
                  contact: contact,


                  /// SMS
                  onSms: () {

                    if (selectedWish.isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Hãy chọn mẫu lời chúc trước"),
                        ),
                      );

                      return;
                    }

                    sendWish(contact);

                    print("Send SMS to ${contact.phone}");
                    print("Message: $selectedWish");
                  },


                  /// GIFT BUTTON
                  onSendWish: () {
                    sendWish(contact);
                  },
                  onSelect: (value) {

                    setState(() {
                      contact.isSelected = value;
                    });

                  },

                );
              },
            ),
          ),
        ],
      ),

      /// PAGE 2 (không dùng vì mở bằng Navigator)
      const SizedBox(),

      /// PAGE 3: THỐNG KÊ
      StatisticsScreen(
        contacts: contacts,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E3),

      body: pages[currentIndex],

      /// BUTTON THÊM MỚI
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
        backgroundColor: Colors.red,

        onPressed: () async {

          final newContact = await showModalBottomSheet<Contact>(
            context: context,
            isScrollControlled: true,

            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),

            builder: (context) {
              return const AddContactScreen();
            },
          );

          if (newContact != null) {
            addContact(newContact);
          }
        },

        icon: const Icon(Icons.add),
        label: const Text("Thêm Mới"),
      )
          : null,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) async {

          /// TAB MẪU LỜI CHÚC
          if (index == 1) {

            final wish = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WishTemplateScreen(),
              ),
            );

            if (wish != null) {
              setState(() {
                selectedWish = wish;
                currentIndex = 0;
              });
            }

          } else {

            setState(() {
              currentIndex = index;
            });

          }
        },

        selectedItemColor: Colors.orange,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Danh bạ",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Mẫu Lời Chúc",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Thống Kê",
          ),
        ],
      ),
    );
  }
}