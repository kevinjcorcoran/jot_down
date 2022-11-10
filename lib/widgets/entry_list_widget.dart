import 'package:flutter/material.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/view_models/entry_view_model.dart';
import 'package:jot_down/widgets/entry_widget.dart';

class EntryListWidget extends StatelessWidget {
  // The view movel used throughout the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function(
      {String title,
      String keyword,
      DateTime? start,
      DateTime? end,
      EntryListViewModel vm})? updateEntries;

  const EntryListWidget({required this.vm, required this.updateEntries});

  @override
  Widget build(BuildContext context) {
    List<EntryViewModel> shownEntries = vm.shownEntries
      ..sort((b, a) => a.time.compareTo(b.time)); // TODO: This sorting will have to be dynamic
    return ListView.separated(
      reverse: true,
      padding: const EdgeInsets.all(10),
      itemCount: shownEntries.length,
      itemBuilder: (context, index) {
        EntryViewModel entry = shownEntries[index];
        return EntryWidget(
          entry: entry,
          updateEntries:
          updateEntries,
          vm: vm
        );
      },
      // Space between entries
      separatorBuilder: (context, index) => const SizedBox(
        height: 7,
      )
    );
  }
}
