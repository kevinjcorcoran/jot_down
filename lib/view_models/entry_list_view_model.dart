import 'package:flutter/material.dart';
import 'package:hashtagable/functions.dart';
import 'package:jot_down/entry_data.dart';
import 'package:jot_down/view_models/entry_view_model.dart';

/// Represents the current state of the [Entry] objects in the app.
///
/// Provides method to update the apps state. [entries] refers to all of the
/// entries created from the device specific JSON. [shown_entries] refers to the
/// entries that shave been filtered out from [entries] to show in the view.
/// [tags] refers to all of the hashtagged words found in the content of the
/// entries in [entries].
class EntryListViewModel extends ChangeNotifier {
  List<EntryViewModel> entries = <EntryViewModel>[];
  List<EntryViewModel> shownEntries = <EntryViewModel>[];
  Set<String> tags = <String>{};

  /// Tells the [EntryData] class to create new [Entry] objects based on the JSON
  /// saved on the device.
  Future<void> fetchEntries() async {
    final results = await EntryData().fetchEntries();
    entries = results.map((item) => EntryViewModel(entry: item)).toList();
    for (var entry in entries) {
      tags.addAll(extractHashTags(entry.content));
    }
    updateShownEntries();
  }

  /// Updates [shownEntries] by filtering [entries] based on a [keyword] or [start]
  /// and [end] date. [keyword] is used to extract both standard string searches
  /// and hashtag extraction.
  void updateShownEntries(
      {String keyword = '',
      DateTime? start,
      DateTime? end,
      bool trash = false}) {
    shownEntries = entries
        .where(
            (entry) => entry.content.contains(keyword) && entry.trash == trash)
        .toList()
      ..sort((b, a) => a.time
          .compareTo(b.time)); //TODO: this sorting will have to be dynamic
    notifyListeners();
  }

  /// Creates a new entry and adds it to [entries] and [tags], then updates [shownEntries].
  Future<void> addEntry(String content) async {
    EntryViewModel entry =
        EntryViewModel(entry: await EntryData().addEntry(content));
    entries.add(entry);
    tags.addAll(extractHashTags(entry.content));
    updateShownEntries();
  }

  Future<void> editEntry(
      {required EntryViewModel entry,
      required String content,
      required DateTime time,
      required bool trash}) async {
    entry.content = content;
    entry.time = time;
    entry.trash = trash;
    EntryData()
        .editEntry(entry.id, content, time, trash);
  }
}
