import 'package:flutter/material.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/widgets/drawer_items_widget.dart';
import 'package:jot_down/widgets/entry_list_widget.dart';
import 'package:jot_down/widgets/new_entry_widget.dart';

import 'package:provider/provider.dart';

class EntryListView extends StatefulWidget {
  @override
  _EntryListViewState createState() => _EntryListViewState();
}

class _EntryListViewState extends State<EntryListView> {
  String title = 'Home'; // Header title, changed via widgets

  // Gets entries from the JSON with optional keyword
  void updateEntries(
      {String title = '',
      String keyword = '',
      DateTime? start,
      DateTime? end,
      EntryListViewModel? vm}) {
    this.title = title;
    vm?.updateShownEntries(keyword: keyword, start: start, end: end);
  }

  // Controller used to track input throughout the app
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<EntryListViewModel>(context, listen: false).fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    final entryListVm = Provider.of<EntryListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Open SearchWidget
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // TODO: Open FilterWidget
            },
          ),
        ],
      ),
      drawer: Drawer(
          child:
              DrawerItemsWidget(updateEntries: updateEntries, vm: entryListVm)),
      body: Column(children: [
        Expanded(
            child:
                EntryListWidget(updateEntries: updateEntries, vm: entryListVm)),
        Container(
            padding: const EdgeInsets.all(10),
            child: NewEntryWidget(
              updateEntries: updateEntries,
              vm: entryListVm,
              controller: controller,
            ))
      ]),
    );
  }
}
