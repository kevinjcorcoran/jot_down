import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:jot_down/styles.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/view_models/entry_view_model.dart';
import 'package:intl/intl.dart';

class EntryWidget extends StatefulWidget {
  // The entry associated with this widget
  final EntryViewModel entry;
  // The view model shared by the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function({String title, String keyword, bool trash})? updateView;

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
  State<EntryWidget> createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget> {
  late TextEditingController textEditingController;

  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

     Future.delayed(Duration.zero,(){
      //Populate text field with entry content
      textEditingController.value = TextEditingValue(
        text: widget.entry.content,
        selection: TextSelection.fromPosition(
          TextPosition(offset: widget.entry.content.length),
        )
      );
    
      selectedDateTime = widget.entry.time;
    });
  
    return ListTile(
        //shape: RoundedRectangleBorder(
        //  side: const BorderSide(
        //      color: Color.fromARGB(255, 212, 212, 212), width: 1),
        //  borderRadius: BorderRadius.circular(10),
        //),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: HashTagText(
              text: widget.entry.content,
              decoratedStyle: bodyAccentText,
              basicStyle: bodyText,
              onTap: (tag) {
                widget.updateView!(title: tag, keyword: tag);
                if (widget.inSearch) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().add_jm().format(widget.entry.time),
                  style: dateText,
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) => buildEntryEditSheet(context)
                    );
                  },
                  padding: const EdgeInsets.only(left: 5),
                  constraints: const BoxConstraints(),
                )
              ],
           )
          ),
        ]),
    );
  }

  //Workaround function for making entry sheet dismissible but also scrollable
  Widget makeDismissible({required Widget child, required BuildContext context}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(child: child)
  );

  Widget buildEntryEditSheet(BuildContext context) => makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.6,
        maxChildSize: 0.8,
        builder: (_, scrollController) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setSheetState) => Container(
                decoration: const BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10)
                    )
                ),
                padding: const EdgeInsets.all(15),
                child: entryEditSheet(context, scrollController, setSheetState)
            ))
    ),
    context: context);

  Widget entryEditSheet(BuildContext context, ScrollController scrollController, StateSetter setSheetState) {

    List<Widget> widgetsToShow = widget.entry.trash
        ? [
            sheetHandle(),
            restoreEntryButton(),
            deleteEntryButton()
          ]
        : [
            sheetHandle(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  undoChangesButton(setSheetState),
                  doneEditingButton(context)
                ]),
            editEntryTextField(),
            editEntryDateTime(context, setSheetState),
            moveToTrashButton(context),
          ];

    return ListView(
      controller: scrollController,
      children: widgetsToShow,
    );
  }

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

  Widget undoChangesButton(StateSetter setSheetState) {
    // If there are no changes, don't display button
    if (widget.entry.content.toString() == textEditingController.text.toString() && widget.entry.time == selectedDateTime) {
      return const SizedBox.shrink();
    }

    return IconButton(
        color: tagColor,
        icon: const Icon(Icons.undo),
        onPressed: () {
          setSheetState(() {
            //Populate text field with entry content
            textEditingController.value = TextEditingValue(
                text: widget.entry.content,
                selection: TextSelection.fromPosition(
                  TextPosition(offset: widget.entry.content.length),
                )
            );

            selectedDateTime = widget.entry.time;
          });
        }
    );
  }

  Widget doneEditingButton(BuildContext context) => Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          widget.vm.editEntry(
              entry: widget.entry,
              content: textEditingController.text,
              time: selectedDateTime,
              trash: false
          );
          widget.updateView!();
          Navigator.pop(context);
        },
        child: const Text('DONE', style: bodyAccentText),
      )

  );

  Widget editEntryTextField() => HashTagTextField(
    controller: textEditingController,
    scrollPadding: const EdgeInsets.all(5.0),
    decoratedStyle: bodyAccentText,
    basicStyle: bodyText,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 10,
    decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide:
          BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide:
          BorderSide(color: borderColor, width: 1),
        ),
        contentPadding: EdgeInsets.only(left: 10),
        hintText: "Edit entry"
    ),
  );

  Widget editEntryDateTime(BuildContext context, StateSetter setSheetState) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally
      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically
      children: [
        Expanded( // Date Picker
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            child: ElevatedButton.icon(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(0, 10, 0, 10))
              ),
              icon: const Icon(Icons.edit),
              label: Text(DateFormat.yMd().format(selectedDateTime), style: buttonText),
              onPressed: () async {
                final date = await pickDate();
                if (date == null) return; // User clicked cancel
                setSheetState(() {
                  selectedDateTime = DateTime(date.year, date.month, date.day, selectedDateTime.hour, selectedDateTime.minute);
                });
              },
            )
          )
        ),
        Expanded( // Time Picker
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            child: ElevatedButton.icon(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(0, 10, 0, 10))
              ),
              icon: const Icon(Icons.edit),
              label: Text(DateFormat.jm().format(selectedDateTime), style: buttonText),
              onPressed: () async {
                final time = await pickTime();
                if (time == null) return; // User clicked cancel
                setSheetState(() {
                  selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, time.hour, time.minute);
                });
              },
            )
          )
        )
      ],
    )
  );

  Future<DateTime?> pickDate() => showDatePicker(

      context: context,
      initialDate: widget.entry.time,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
              primaryColor: tagColor,
              colorScheme: const ColorScheme.dark(primary: tagColor),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.normal
              ),
          ),
          child: child!,
        );
      },
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.entry.time),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
              primaryColor: tagColor,
              colorScheme: const ColorScheme.dark(primary: tagColor),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.normal
              ),
          ),
          child: child!,
        );
      },
  );

  Widget moveToTrashButton(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 10),
    child: ElevatedButton.icon(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(0, 10, 0, 10))
        ),
        icon: const Icon(Icons.delete),
        label: const Text("Move to Trash", style: buttonText),
        onPressed: () {
          EntryWidget trashing = widget; //Keep reference to widget for undoing trash in snackbar

          widget.vm.editEntry(
              entry: widget.entry,
              content: widget.entry.content,
              time: widget.entry.time,
              trash: true
          );
          widget.updateView!();

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Moved Entry to Trash'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                trashing.vm.editEntry(
                    entry: trashing.entry,
                    content: trashing.entry.content,
                    time: trashing.entry.time,
                    trash: false);
                trashing.updateView!();
              },
            ),
          ));
        }
    ),
  );

  Widget restoreEntryButton() => Container(
    margin: const EdgeInsets.only(top: 10),
    child: ElevatedButton.icon(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(0, 10, 0, 10))
        ),
        icon: const Icon(Icons.restore),
        label: const Text("Restore", style: buttonText),
        onPressed: () {
          EntryWidget trashing = widget; //Keep reference to widget for undoing trash in snackbar

          widget.vm.editEntry(
              entry: widget.entry,
              content: widget.entry.content,
              time: widget.entry.time,
              trash: false
          );
          widget.updateView!();

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Entry Restored'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                trashing.vm.editEntry(
                    entry: trashing.entry,
                    content: trashing.entry.content,
                    time: trashing.entry.time,
                    trash: true);
                trashing.updateView!();
              },
            ),
          ));
        }
    ),
  );

  Widget deleteEntryButton()  => Container(
    margin: const EdgeInsets.only(top: 10),
    child: ElevatedButton.icon(
        icon: const Icon(Icons.delete_forever),
        label: const Text("Delete", style: buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10)
        ),
        onPressed: () {
          widget.vm.deleteEntry(entry: widget.entry);
          widget.updateView!();
          Navigator.pop(context);
        }
    ),
  );
}
