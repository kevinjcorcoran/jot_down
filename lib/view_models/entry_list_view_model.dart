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
      bool trash = false}) {
    List<EntryViewModel> entries = <EntryViewModel>[];
    (trash) ? entries = trashEntries : entries = validEntries;
    if (keyword == '') {
      shownEntries = entries;
    } else {
      shownEntries = entries
          .where((entry) =>
              // Check if [entry.content] contains any of the words in the [keyword] string
              (entry.content
                  .toLowerCase()
                  .split(' ')
                  .toSet()
                  .intersection(keyword.toLowerCase().split(' ').toSet())
                  .isNotEmpty) &&
              entry.trash == trash)
          .toList();
    }
    shownEntries.sort((b, a) =>
        a.time.compareTo(b.time)); //TODO: this sorting will have to be dynamic

    tags.clear();
    for (var entry in validEntries) {
      tags.addAll(extractHashTags(entry.content));
    }
    notifyListeners();
  }

  // Need a better way to manage this stuff
  // When something is trashed, remove it from shown entries
  // Should tags get its info from shown entries?
  // Problem was that when a tag was removed when editing it didn't update on tags
  // This is because it was never removed! Only thing that removes tags is deleting entries
  // Currently have entries and shownEntries
  // Do we want tags to completely update every time?
  // Could have trashEntries
  // validEntries

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
