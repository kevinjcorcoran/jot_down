import 'package:flutter/material.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/widgets/drawer_items_widget.dart';
import 'package:jot_down/widgets/entry_list_widget.dart';
import 'package:jot_down/widgets/new_entry_widget.dart';
import 'package:jot_down/widgets/search_widget.dart';

import 'package:provider/provider.dart';

class EntryListView extends StatefulWidget {
  const EntryListView({super.key});
  @override
  EntryListViewState createState() => EntryListViewState();
}

class EntryListViewState extends State<EntryListView> {
  String title = 'Home'; // Header title, changed via widgets

  /// Controller used to track input throughout the app
  final TextEditingController controller = TextEditingController();

  /// Initializes the state of the app and fetches the entries from the JSON
  @override
  void initState() {
    super.initState();
    Provider.of<EntryListViewModel>(context, listen: false).fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    /// The view model used to manage the state of the app
    final entryListVm = Provider.of<EntryListViewModel>(context);

    /// Gets entries from the view model based on the parameters.
    ///
    /// [title] lets the child widgets update the title on in the AppBar
    /// [keyword] lets child widgets update entries based on a keyword/tag
    /// TODO: [start] and [end] allows [FilterWidget] to filter by date
    /// [trash] allows [DrawerItemsWidget] to show entries marked as trash
    void updateView(
        {String title = '',
        String keyword = '',
        DateTime? start,
        DateTime? end,
        bool trash = false}) {
      this.title = title;
      entryListVm.updateShownEntries(
          keyword: keyword, start: start, end: end, trash: trash);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchWidget(updateView: updateView));
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
          child: DrawerItemsWidget(
              updateView: updateView, tags: entryListVm.tags)),
      body: Column(children: [
        Expanded(
            child: EntryListWidget(
          updateView: updateView,
          shownEntries: entryListVm.shownEntries,
        )),
        Container(
            padding: const EdgeInsets.all(10),
            child: NewEntryWidget(
              updateView: updateView,
              vm: entryListVm,
              controller: controller,
            ))
      ]),
    );
  }
}
