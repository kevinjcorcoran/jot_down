import 'package:flutter/material.dart';

class DrawerItemsWidget extends StatelessWidget {
  /// The set of tags to show in the drawer
  final Set<String> tags;
  // Updates the view model when changes are made
  final Function({String title, String keyword, bool trash})? updateView;

  const DrawerItemsWidget(
      {super.key, required this.updateView, required this.tags});

  @override
  Widget build(BuildContext context) {
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
                updateView!(title: 'Home');
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
                updateView!(title: 'Trash', trash: true);
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
              updateView!(title: tag, keyword: tag);
              Navigator.pop(context);
            });
      },
    );
  }
}
