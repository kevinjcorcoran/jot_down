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
  List<EntryViewModel> validEntries = <EntryViewModel>[];
  List<EntryViewModel> trashEntries = <EntryViewModel>[];
  List<EntryViewModel> shownEntries = <EntryViewModel>[];
  Set<String> tags = <String>{};

  /// Tells the [EntryData] class to create new [Entry] objects based on the JSON
  /// saved on the device.
  Future<void> fetchEntries() async {
    final results = await EntryData().fetchEntries();
    validEntries = [];
    trashEntries = [];
    for (var item in results) {
      EntryViewModel entry = EntryViewModel(entry: item);
      if (entry.trash) {
        trashEntries.add(entry);
      } else {
        validEntries.add(entry);
      }
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
      bool sortAsc = false,
      bool trash = false}) {
    List<EntryViewModel> entries = <EntryViewModel>[];
    (trash) ? entries = trashEntries : entries = validEntries;
    if (keyword == '' && start == null && end == null) {
      shownEntries = entries;
    } else if (start == null && end == null) {
      shownEntries = entries
          .where((entry) =>
              // Check if [entry.content] contains any of the words in the [keyword] string
              (entry.content
                  .toLowerCase()
                  .split(' ')
                  .toSet()
                  .intersection(keyword.toLowerCase().split(' ').toSet())
                  .isNotEmpty)
              && (entry.trash == trash))
          .toList();
    } else if (keyword == '' && start != null && end != null) {
        shownEntries = entries
          .where((entry) =>
              // Check if [entry.content] contains any of the words in the [keyword] string
              (entry.trash == trash)
              // Check if the entry is between the time constraints
              && (entry.time.compareTo(start) >= 0)
              && (entry.time.compareTo(end) <= 0))
          .toList();
    } else {
      shownEntries = entries
          .where((entry) =>
            (entry.content
                  .toLowerCase()
                  .split(' ')
                  .toSet()
                  .intersection(keyword.toLowerCase().split(' ').toSet())
                  .isNotEmpty)
              // Check if [entry.content] contains any of the words in the [keyword] string
              && (entry.trash == trash)
              // Check if the entry is between the time constraints
              && (entry.time.compareTo(start!) >= 0)
              && (entry.time.compareTo(end!) <= 0))
          .toList();
    }

    if (sortAsc) {
      shownEntries.sort((a, b) =>
        a.time.compareTo(b.time));
    } else 
    {
      shownEntries.sort((b, a) =>
        a.time.compareTo(b.time));
    }

    tags.clear();
    for (var entry in validEntries) {
      tags.addAll(extractHashTags(entry.content));
    }
    notifyListeners();
  }

  /// Creates a new entry and adds it to [entries] and [tags], then updates [shownEntries].
  Future<void> addEntry(String content) async {
    EntryViewModel entry =
        EntryViewModel(entry: await EntryData().addEntry(content));
    validEntries.add(entry);
    tags.addAll(extractHashTags(entry.content));
    updateShownEntries();
  }

  Future<void> editEntry(
      {required EntryViewModel entry,
      required String content,
      required DateTime time,
      required bool trash}) async {
    if (entry.trash != trash) {
      if (trash) {
        validEntries.remove(entry);
        trashEntries.add(entry);
      } else {
        trashEntries.remove(entry);
        validEntries.add(entry);
      }
      entry.trash = trash;
    }
    entry.content = content;
    entry.time = time;
    EntryData().editEntry(entry.id, content, time, trash);
    updateShownEntries();
  }

  Future<void> deleteEntry({required EntryViewModel entry}) async {
    EntryData().deleteEntry(entry.id);
    trashEntries.remove(entry);
    updateShownEntries();
  }
}
