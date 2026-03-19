import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WishTemplateScreen extends StatefulWidget {
  const WishTemplateScreen({super.key});

  @override
  State<WishTemplateScreen> createState() => _WishTemplateScreenState();
}

class _WishTemplateScreenState extends State<WishTemplateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  final List<Map<String, dynamic>> _defaultWishes = [
    {
      "category": "Gia đình",
      "content": "Chúc ông bà, cha mẹ năm mới bách niên giai lão, thọ tỷ nam sơn, sức khỏe dồi dào, vui vầy cùng con cháu!",
      "isCustom": false,
    },
    {
      "category": "Bạn bè",
      "content": "Năm mới chúc bạn: Đau đầu vì nhà giàu, mệt mỏi vì học giỏi, buồn phiền vì nhiều tiền, ngang trái vì xinh gái!",
      "isCustom": false,
    },
    {
      "category": "Công việc",
      "content": "Chúc bạn năm mới công danh rạng rỡ, sự nghiệp thăng tiến, mã đáo thành công, vạn sự như ý!",
      "isCustom": false,
    },
    {
      "category": "Truyền thống",
      "content": "Chúc mừng năm mới 2026! An khang thịnh vượng - Vạn sự như ý - Phát tài phát lộc!",
      "isCustom": false,
    },
    {
      "category": "Hài hước",
      "content": "Chúc mừng năm mới! Chúc bạn 12 tháng phú quý, 365 ngày phát tài, 8760 giờ sung túc, 525600 phút thành công!",
      "isCustom": false,
    },
  ];

  final List<Map<String, dynamic>> _customWishes = [];

  List<Map<String, dynamic>> get _allWishes => [..._defaultWishes, ..._customWishes];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fabAnimation = CurvedAnimation(parent: _fabController, curve: Curves.elasticOut);
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _openAddWishSheet({Map<String, dynamic>? editItem, int? editIndex}) {
    final contentController = TextEditingController(text: editItem?['content'] ?? '');
    String selectedCategory = editItem?['category'] ?? 'Của tôi';
    final isEditing = editItem != null;
    final categories = ['Của tôi', 'Gia đình', 'Bạn bè', 'Công việc', 'Truyền thống', 'Hài hước', 'Khác'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, bottomInset + 24),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF9F0),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50, height: 5,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isEditing ? "✏️ Chỉnh sửa lời chúc" : "✍️ Thêm lời chúc của bạn",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)),
                ),
                const SizedBox(height: 20),
                const Text("Danh mục:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: categories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? const Color(0xFFD32F2F) : Colors.grey.shade300),
                        ),
                        child: Text(cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  maxLength: 300,
                  decoration: InputDecoration(
                    labelText: "Nội dung lời chúc",
                    labelStyle: const TextStyle(color: Colors.brown),
                    hintText: "Nhập lời chúc của bạn tại đây...",
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final content = contentController.text.trim();
                      if (content.isEmpty) return;
                      setState(() {
                        final newWish = {"category": selectedCategory, "content": content, "isCustom": true};
                        if (isEditing && editIndex != null) {
                          _customWishes[editIndex] = newWish;
                        } else {
                          _customWishes.add(newWish);
                        }
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(isEditing ? "Đã cập nhật lời chúc 🎊" : "Đã thêm lời chúc mới 🎊"),
                        backgroundColor: const Color(0xFF27AE60),
                      ));
                    },
                    icon: Icon(isEditing ? Icons.check : Icons.add),
                    label: Text(isEditing ? "LƯU THAY ĐỔI" : "THÊM LỜI CHÚC",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _confirmDelete(int customIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Xóa lời chúc?"),
        content: const Text("Bạn có chắc muốn xóa lời chúc này không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              setState(() => _customWishes.removeAt(customIndex));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã xóa lời chúc"), backgroundColor: Colors.grey),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFE),
      appBar: AppBar(
        title: const Text("📜 Kho Lời Chúc Tết",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _openAddWishSheet(),
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text("Thêm lời chúc", style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 6,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text("Chọn một lời chúc ý nghĩa để gửi trao yêu thương",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge("${_defaultWishes.length} mẫu có sẵn", Colors.orange),
                    const SizedBox(width: 8),
                    _buildBadge("${_customWishes.length} lời chúc của tôi", Colors.green),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              itemCount: _allWishes.length,
              itemBuilder: (context, index) {
                final wish = _allWishes[index];
                final isCustom = wish['isCustom'] == true;
                final customIndex = isCustom ? index - _defaultWishes.length : -1;
                return _buildWishCard(context, wish['category']!, wish['content']!, index,
                    isCustom: isCustom, customIndex: customIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWishCard(BuildContext context, String category, String content, int index,
      {required bool isCustom, required int customIndex}) {
    final colors = [
      const Color(0xFFD32F2F), const Color(0xFFE67E22),
      const Color(0xFF27AE60), const Color(0xFF8E44AD), const Color(0xFF2980B9),
    ];
    final cardColor = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: cardColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: cardColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(19), bottomRight: Radius.circular(14)),
                ),
                child: Row(
                  children: [
                    if (isCustom) ...[Icon(Icons.edit_note, size: 14, color: cardColor), const SizedBox(width: 4)],
                    Text(category, style: TextStyle(color: cardColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              if (isCustom)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: const Text("✨ Của tôi",
                      style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(content,
                style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF2D3436), fontStyle: FontStyle.italic)),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: "Sao chép",
                icon: Icon(Icons.copy_rounded, size: 20, color: Colors.grey.shade500),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã sao chép lời chúc"), duration: Duration(seconds: 1)));
                },
              ),
              if (isCustom)
                IconButton(
                  tooltip: "Chỉnh sửa",
                  icon: Icon(Icons.edit_rounded, size: 20, color: Colors.blue.shade400),
                  onPressed: () => _openAddWishSheet(editItem: _allWishes[index], editIndex: customIndex),
                ),
              if (isCustom)
                IconButton(
                  tooltip: "Xóa",
                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red.shade300),
                  onPressed: () => _confirmDelete(customIndex),
                ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context, content),
                icon: Icon(Icons.send_rounded, size: 18, color: cardColor),
                label: Text("Dùng ngay", style: TextStyle(color: cardColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}