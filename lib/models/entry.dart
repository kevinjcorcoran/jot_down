/// Represents a single [Entry] and its data.
///
/// Each [Entry] has a unique [id], the [time] it was created, its [content] as
/// a string, and a [trash] boolean signifying if it has been marked to delete
/// by the user.
class Entry {
  final String id;
  DateTime time;
  String content;
  bool trash;

  Entry(
      {required this.id,
      required this.time,
      required this.content,
      required this.trash});

  /// Creates an [Entry] based on the data outlined in the device specific JSON file.
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
        id: json["id"],
        time: DateTime.parse(json["time"]),
        content: json["content"],
        trash: json["trash"]);
  }
}
