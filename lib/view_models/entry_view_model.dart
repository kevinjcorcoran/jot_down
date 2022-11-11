import 'package:jot_down/models/entry.dart';

/// Provides methods to indirectly interact with [Entry] objects.
class EntryViewModel {
  final Entry entry;

  EntryViewModel({required this.entry});

  String get id {
    return entry.id;
  }

  DateTime get time {
    return entry.time;
  }

  String get content {
    return entry.content;
  }

  bool get trash {
    return entry.trash;
  }
}
