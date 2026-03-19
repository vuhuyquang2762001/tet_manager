class Wish {
  int? id;
  String content;

  Wish({
    this.id,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map["id"],
      content: map["content"],
    );
  }
}