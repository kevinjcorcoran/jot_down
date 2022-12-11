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
  final Function({String title, String keyword, bool trash})? updateView;

  final TextEditingController textEditingController = TextEditingController();


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
        onTap: () {
          textEditingController.value = TextEditingValue(
            text: entry.content,
            selection: TextSelection.fromPosition(
              TextPosition(offset: entry.content.length),
            )
          );

          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) => buildEntryEditSheet(context)
          );
        }
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
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10)
              )
          ),
          padding: const EdgeInsets.all(15),
          child: entryEditSheet(context, scrollController)
        )
    ),
    context: context);
  
  Widget entryEditSheet(BuildContext context, ScrollController scrollController) => ListView(
    controller: scrollController,
    children: [
      sheetHandle(),
      doneEditingButton(context),
      editEntryTextField(),
      moveToTrashButton(context),
    ],
  );

  Widget sheetHandle() => FractionallySizedBox(
    widthFactor: 0.1,
    child: Container(
      height: 5.0,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius:  BorderRadius.all(Radius.circular(2.5)),
      ),
    ),
  );

  Widget doneEditingButton(BuildContext context) => Align(
      alignment: Alignment.topRight,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          vm.editEntry(
              entry: entry,
              content: textEditingController.text,
              time: entry.time,
              trash: false
          );
          updateView!();
          Navigator.pop(context);
        },
        child: const Text('DONE'),
      )

  );

  Widget editEntryTextField() => HashTagTextField(
    controller: textEditingController,
    scrollPadding: const EdgeInsets.all(5.0),
    decoratedStyle: const TextStyle(fontSize: 20, color: Colors.blue),
    basicStyle: const TextStyle(fontSize: 20, color: Colors.black),
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 10,
    decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide:
          BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide:
          BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
        ),
        contentPadding: EdgeInsets.only(left: 10),
        hintText: "Edit entry"
    ),
  );

  Widget moveToTrashButton(BuildContext context) => ElevatedButton.icon(
    icon: const Icon(Icons.delete),
    label: const Text("Move to Trash"),
    onPressed: () {
      vm.editEntry(
        entry: entry,
        content: entry.content,
        time: entry.time,
        trash: true
      );
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
  );

}
