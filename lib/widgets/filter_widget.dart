import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jot_down/styles.dart';

class FilterWidget extends StatefulWidget {
  // Updates the view model when changes are made
  final Function({DateTime? start, DateTime? end, bool? sortAsc})? updateView;

  const FilterWidget({
    super.key,
    required this.updateView,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late DateTime startDate;
  late DateTime endDate;
  late bool sortAsc;

  @override
  void initState() {
    startDate = DateTime.now();
    endDate = DateTime.now();
    sortAsc = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) => ListView(
        children: [
          doneFilteringButton(context),
          // TODO: ADD SORT ASC DESC CHOOSER HERE
          pickDate(context, stateSetter, "Start Date:", startDate),
          pickDate(context, stateSetter, "End Date:", endDate),
          clearFilteringButton(context),
        ],
      ),
    );
  }

 Widget doneFilteringButton(BuildContext context) => ListTile(
      trailing: TextButton(
        onPressed: () {
          widget.updateView!(start: startDate, end: endDate, sortAsc: sortAsc);
          Navigator.pop(context);
        },
        child: const Text('APPLY', style: bodyAccentText),
      ));

  // TODO: IMPLEMENT SORT ASC DESC CHOOSER HERE
  // This can be done almost exactly the same as the other buttons in this file
  // Try to use a DropDownButton for it with two options: Ascending, Descending
  // Docs: https://api.flutter.dev/flutter/material/DropdownButton-class.html
  // Use onChanged to call updateView(sortAsc: true) for Ascending, 
  // and updateView(sortAsc: false) for Descending

  Widget pickDate(BuildContext context, StateSetter stateSetter, String option,
          DateTime dateOption) =>
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 15),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10), 
          child: Text(option, style: bodyText,)
        ),
        subtitle: Expanded(
            // Start Date Picker
            child: Container(
                margin: const EdgeInsets.only(right: 5),
                child: ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(backgroundColor),
                      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(0, 10, 0, 10))
                  ),
                  icon: const Icon(Icons.edit),
                  label: Text(DateFormat.yMd().format(dateOption), style: buttonText),
                  onPressed: () async {
                    final date = await datePicker(dateOption);
                    if (date == null) return; // User clicked cancel
                    stateSetter(() {
                      dateOption = DateTime(date.year, date.month, date.day,
                          dateOption.hour, dateOption.minute);
                    });
                  },
                ))),
      );

  Future<DateTime?> datePicker(initDate) => showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: tagColor,
              colorScheme: const ColorScheme.dark(primary: tagColor),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.normal),
            ),
            child: child!,
          );
        },
      );

  Widget clearFilteringButton(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: ElevatedButton.icon(
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(backgroundColor),
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(0, 15, 0, 15))
            ),
            icon: const Icon(Icons.cancel),
            label: const Text("Clear Filtering", style: buttonText),
            onPressed: () {
              widget.updateView!(start: DateTime(1900), end: DateTime(2100));
              Navigator.pop(context);
            }),
      );
}
