import 'package:flutter/material.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/widgets/entry_list_widget.dart';

class SearchWidget extends SearchDelegate {
  final Function({String title, String keyword})? updateView;
  SearchWidget({required this.updateView});
  /// Search has its own viewmodel to prevent it from affecting the rest of the 
  /// app's state
  EntryListViewModel vm = EntryListViewModel();

  /// Action to clear search bar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  /// Action to close search bar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  /// When search is submitted, the entries including the search are shown
  /// Passes true to inSearch, so that when a tag on one of the shown entries
  /// is clicked, the search bar is closed and the screen moves to the page for
  /// that tag.
  @override
  Widget buildResults(BuildContext context) {
    vm.fetchEntries();
    vm.updateShownEntries(keyword: query);

    return EntryListWidget(
        vm: vm, updateView: updateView, inSearch: true);
  }

  /// Shows suggestions based on comparing the current text in the search bar
  /// to every word in every entry. When a suggestion is tapped, the search is
  /// submitted with that suggestion.
  @override
  Widget buildSuggestions(BuildContext context) {
    vm.fetchEntries();
    Set<String> matchQuery = {};
    for (var entry in vm.entries) {
      List<String> content = entry.content.toLowerCase().split(' ');
      matchQuery.addAll(content.where((word) => word.startsWith(query)));
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery.elementAt(index);
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result;
            showResults(context);
          },
        );
      },
    );
  }
}
