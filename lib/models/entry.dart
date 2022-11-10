class Entry {
  final String id;
  DateTime time;
  String content;
  bool trashed;

  Entry({
    required this.id,
    required this.time,
    required this.content,
    required this.trashed
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json["id"],
      time: DateTime.parse(json["time"]),
      content: json["content"],
      trashed: json["trashed"]
    );
  }
}
