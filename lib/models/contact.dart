class Contact {
  int? id;
  String name;
  String phone;
  String groupName;
  String note;

  int greeted; // 0 = chưa chúc, 1 = đã chúc
  String sentWish; // nội dung lời chúc đã gửi

  bool isSelected; // checkbox chọn gửi hàng loạt (không lưu DB)

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.groupName,
    required this.note,
    this.greeted = 0,
    this.sentWish = "",
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "groupName": groupName,
      "note": note,
      "greeted": greeted,
      "sentWish": sentWish,
      // KHÔNG thêm isSelected vào DB
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map["id"],
      name: map["name"],
      phone: map["phone"],
      groupName: map["groupName"],
      note: map["note"],
      greeted: map["greeted"] ?? 0,
      sentWish: map["sentWish"] ?? "",
      isSelected: false,
    );
  }
}