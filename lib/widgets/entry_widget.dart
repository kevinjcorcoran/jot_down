import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/view_models/entry_view_model.dart';
import 'package:intl/intl.dart';

class EntryWidget extends StatelessWidget {
  // The entry associated with this widget
  final EntryViewModel entry;
  // The view model shared by the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function({String title, String keyword})? updateView;

  /// Signifies if search widget is open, if so, pop the context on tag click to
  /// close the search
  bool inSearch;

  EntryWidget(
      {super.key,
      required this.vm,
      required this.entry,
      required this.updateView,
      this.inSearch = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color.fromARGB(255, 212, 212, 212), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: HashTagText(
              text: entry.content,
              decoratedStyle: const TextStyle(fontSize: 20, color: Colors.blue),
              basicStyle: const TextStyle(fontSize: 20, color: Colors.black),
              onTap: (tag) {
                updateView!(title: tag, keyword: tag);
                if (inSearch) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Row(children: [
                IconButton(
                    padding: const EdgeInsets.only(right: 5),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      vm.editEntry(
                          entry: entry,
                          content: entry.content,
                          time: entry.time,
                          trash: true);
                      updateView!(title: "Home");

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Moved Entry to Trash'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            vm.editEntry(
                                entry: entry,
                                content: entry.content,
                                time: entry.time,
                                trash: false);
                            updateView!(title: "Home");
                          },
                        ),
                      ));
                    }),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement an new Edit Widget
                  },
                ),
              ])),
              // EditButton
              Text(DateFormat.yMMMd().add_jm().format(entry.time))
            ],
          )
        ]));
  }
}
