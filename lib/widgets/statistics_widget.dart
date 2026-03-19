import 'package:flutter/material.dart';
import '../models/contact.dart';

class StatisticsWidget extends StatelessWidget {
  final List<Contact> contacts;

  const StatisticsWidget({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    // Logic tính toán
    int total = contacts.length;
    // Kiểm tra status dựa trên biến greeted hoặc note tùy model của bạn
    int wished = contacts.where((c) => c.greeted == 1 || c.note == "Đã gửi lời chúc").length;
    int remaining = total - wished;
    double progress = total == 0 ? 0 : wished / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(progress, wished, remaining, total),
          const SizedBox(height: 30),
          const Text(
            "🎋 Tiến độ theo nhóm",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
          ),
          const SizedBox(height: 15),
          _buildGroupStatsGrid(), // Đổi sang dạng lưới cho hiện đại
          const SizedBox(height: 20),
          _buildMotivationCard(remaining),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(double progress, int wished, int remaining, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD32F2F).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "TỔNG QUAN XUÂN 2026",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)), // Màu vàng Gold
                ),
              ),
              Column(
                children: [
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Text("Hoàn thành", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _headerStatItem(wished.toString(), "Đã chúc", Icons.check_circle),
                _headerStatItem(remaining.toString(), "Chưa chúc", Icons.pending),
                _headerStatItem(total.toString(), "Tổng cộng", Icons.people),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _headerStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildGroupStatsGrid() {
    Map<String, List<Contact>> groups = {};
    for (var c in contacts) {
      groups.putIfAbsent(c.groupName, () => []);
      groups[c.groupName]!.add(c);
    }

    if (groups.isEmpty) return const Center(child: Text("Chưa có dữ liệu nhóm"));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.4,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        String groupName = groups.keys.elementAt(index);
        List<Contact> groupContacts = groups[groupName]!;
        int total = groupContacts.length;
        int wished = groupContacts.where((c) => c.greeted == 1 || c.note == "Đã gửi lời chúc").length;
        double percent = total == 0 ? 0 : wished / total;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$wished/$total người", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      Text("${(percent * 100).toInt()}%", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 5,
                      backgroundColor: Colors.red.withOpacity(0.05),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildMotivationCard(int remaining) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text("🧧", style: TextStyle(fontSize: 30)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Lời nhắn từ Xuân", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                Text(
                  remaining > 0
                      ? "Bạn còn $remaining lời chúc chưa gửi. Đừng để niềm vui chờ đợi nhé!"
                      : "Tuyệt vời! Bạn đã gửi trao yêu thương đến tất cả mọi người.",
                  style: TextStyle(fontSize: 13, color: Colors.brown.shade700),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}