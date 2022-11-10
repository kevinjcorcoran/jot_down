import 'package:jot_down/models/entry.dart';

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

  bool get trashed {
    return entry.trashed;
  }
}
