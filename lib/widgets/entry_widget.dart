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
            padding: const EdgeInsets.only(top: 5, bottom: 5),
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
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(DateFormat.yMMMd().add_jm().format(entry.time)),
          )
        ]),
        onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) => buildEntryEditSheet(context)
        )
    );
  }

  Widget makeDismissible({required Widget child, required BuildContext context}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(child: child)
  );

  Widget buildEntryEditSheet(BuildContext context) => makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10)
              )
          ),
          padding: const EdgeInsets.all(15),
          child: entryEditSheet(context, controller)
        )
    ),
    context: context);
  
  Widget entryEditSheet(BuildContext context, ScrollController controller) => ListView(
    controller: controller,
    children: [
      ElevatedButton.icon(
        icon: const Icon(Icons.delete),
        label: const Text("Move to Trash"),
        onPressed: () {
          vm.editEntry(
              entry: entry,
              content: entry.content,
              time: entry.time,
              trash: true);
          updateView!();

          Navigator.pop(context);

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
                updateView!();
              },
            ),
          ));
        }
      ),
    ],
  );

}
