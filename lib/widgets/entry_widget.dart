import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/view_models/entry_view_model.dart';
import 'package:intl/intl.dart';

class EntryWidget extends StatelessWidget {
  // The entry associated with this widget
  final EntryViewModel entry;
  // The view movel used throughout the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function(
      {String title,
      String keyword,
      DateTime? start,
      DateTime? end,
      EntryListViewModel vm})? updateEntries;

  const EntryWidget(
      {required this.entry, required this.vm, required this.updateEntries});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(255, 212, 212, 212), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HashTagText(
            text: entry.content,
            decoratedStyle: const TextStyle(fontSize: 20, color: Colors.blue),
            basicStyle: const TextStyle(fontSize: 20, color: Colors.black),
            onTap: (tag) {
              updateEntries!(title: tag, keyword: tag, vm: vm);
            },
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 5),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // TODO: Implement Trash
                      }
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implement Edit
                      },
                    ),
                  ]
                )
              ),
              // EditButton
              Text(DateFormat.yMMMd().add_jm().format(entry.time))
            ],
          )
        ]
      )
    );
  }
}
