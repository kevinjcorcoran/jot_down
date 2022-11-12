import 'package:flutter/material.dart';
import 'package:jot_down/view_models/entry_view_model.dart';
import 'package:jot_down/widgets/entry_widget.dart';

class EntryListWidget extends StatelessWidget {
  /// The entries to show in the list
  final List<EntryViewModel> shownEntries;
  // Updates the view model when changes are made
  final Function({String title, String keyword})? updateView;
  /// Signifies is the search widget is open. Not required as it is only used
  /// by SearchWidget
  bool inSearch;

  EntryListWidget(
      {super.key, required this.shownEntries, required this.updateView, this.inSearch = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        reverse: true,
        padding: const EdgeInsets.all(10),
        itemCount: shownEntries.length,
        itemBuilder: (context, index) {
          EntryViewModel entry = shownEntries[index];
          return EntryWidget(
            entry: entry,
            updateView: updateView,
            inSearch: inSearch,
          );
        },
        // Space between entries
        separatorBuilder: (context, index) => const SizedBox(
              height: 7,
            ));
  }
}
