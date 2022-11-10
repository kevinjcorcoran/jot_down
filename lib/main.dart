import 'package:flutter/material.dart';
import 'package:jot_down/views/entry_list_view.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => EntryListViewModel(),
        child: EntryListView(),
      )
    );
  }
}
