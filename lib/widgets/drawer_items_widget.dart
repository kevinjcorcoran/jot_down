import 'package:flutter/material.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';

class DrawerItemsWidget extends StatelessWidget {
  // The view movel used throughout the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function(
      {String title,
      String keyword,
      DateTime? start,
      DateTime? end,
      EntryListViewModel vm})? updateEntries;

  const DrawerItemsWidget({required this.updateEntries, required this.vm});

  @override
  Widget build(BuildContext context) {
    Set<String> tags = vm.tags;
    return ListView.builder(
      itemCount: tags.length + 2,
      itemBuilder: (context, index) {
        // Add a "Home" item at the beginning
        if (index == 0) {
          return ListTile(
              minLeadingWidth: 10,
              leading: const Icon(Icons.home),
              title: const Text('Home', style: TextStyle(fontSize: 20)),
              onTap: () {
                updateEntries!(title: 'Home', vm: vm);
                Navigator.pop(context);
              });
        }
        // Add a "Trash" item second
        if (index == 1) {
          return ListTile(
              minLeadingWidth: 10,
              leading: const Icon(Icons.delete),
              title: const Text('Trash', style: TextStyle(fontSize: 20)),
              onTap: () {
                // TODO: updateEntries!(title: 'Trash', vm: vm TRASH BOOL)
                Navigator.pop(context);
              });
        }
        // Reset the index and add the rest of the dynamicaly generated  items
        index -= 2;
        String tag = tags.elementAt(index);
        return ListTile(
            title: Text(tag,
                style: const TextStyle(fontSize: 20, color: Colors.blue)),
            onTap: () {
              updateEntries!(title: tag, keyword: tag, vm: vm);
              Navigator.pop(context);
            });
      },
    );
  }
}
