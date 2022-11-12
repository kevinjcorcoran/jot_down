import 'package:flutter/material.dart';
import 'package:jot_down/views/entry_list_view.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => EntryListViewModel(),
        child: const EntryListView(),
      )
    );
  }
}
