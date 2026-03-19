import 'package:flutter/material.dart';
import '../models/contact.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedGroup = "Gia đình"; // Mặc định chọn nhóm

  // Danh sách các nhóm để chọn
  final List<String> groups = ["Gia đình", "Bạn bè", "Đồng nghiệp", "Khác"];

  void save() {
    if (nameController.text.isEmpty) return; // Tránh lưu rỗng

    Contact contact = Contact(
      name: nameController.text,
      phone: phoneController.text,
      groupName: selectedGroup,
      note: "",
    );

    Navigator.pop(context, contact);
  }

  @override
  Widget build(BuildContext context) {
    // Lấy padding của keyboard để tránh bị che khi nhập liệu
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, bottomInset + 20),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF9F0), // Nền trắng kem nhẹ nhàng
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo nhỏ phía trên để user biết có thể vuốt xuống
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "🧧 Thêm Người Thân",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F), // Màu đỏ Tết
              fontFamily: 'PlayfairDisplay', // Nếu bạn có font nghệ thuật
            ),
          ),

          const SizedBox(height: 25),

          // Input Tên
          _buildTextField(
            controller: nameController,
            label: "Tên người cần chúc",
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 15),

          // Input Số điện thoại
          _buildTextField(
            controller: phoneController,
            label: "Số điện thoại",
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 15),

          // Chọn nhóm (Dropdown)
          const Text("Nhóm quan hệ:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGroup,
                isExpanded: true,
                items: groups.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedGroup = val!),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Nút Lưu (Gradient Đỏ Vàng)
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.red.withOpacity(0.5),
              ),
              child: const Text(
                "LƯU VÀO DANH SÁCH",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hỗ trợ tạo TextField đẹp
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.brown),
        prefixIcon: Icon(icon, color: const Color(0xFFD32F2F)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
      ),
    );
  }
}