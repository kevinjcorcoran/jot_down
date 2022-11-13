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

  set time(DateTime newValue) {
    entry.time = newValue;
  }

  String get content {
    return entry.content;
  }

  set content(String newValue) {
    entry.content = newValue;
  }

  bool get trash {
    return entry.trash;
  }

  set trash(bool newValue) {
    entry.trash = newValue;
  }
}
