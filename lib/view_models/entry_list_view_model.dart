import 'package:flutter/material.dart';
import 'package:hashtagable/functions.dart';
import 'package:jot_down/entry_data.dart';
import 'package:jot_down/view_models/entry_view_model.dart';

class EntryListViewModel extends ChangeNotifier {
  List<EntryViewModel> entries = <EntryViewModel>[];
  List<EntryViewModel> shownEntries = <EntryViewModel>[];
  Set<String> tags = <String>{};

  Future<void> fetchEntries(
      {String keyword = '', DateTime? start, DateTime? end}) async {
    final results = await EntryData().fetchEntries();
    entries = results.map((item) => EntryViewModel(entry: item)).toList();
    for (var entry in entries) {
      tags.addAll(extractHashTags(entry.content));
    }
    shownEntries = entries
      .where((entry) => entry.content.contains(keyword)).toList();
    notifyListeners();
  }
}
