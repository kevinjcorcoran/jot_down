import 'package:flutter/material.dart';
import 'package:jot_down/styles.dart';
import 'package:jot_down/views/entry_list_view.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          displayLarge: headingText,
          displayMedium: headingText,
        ),
        iconTheme: const IconThemeData(color: secondaryTextColor),
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: secondaryTextColor),
            iconTheme: IconThemeData(
              color: secondaryTextColor),
            backgroundColor: panelColor
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: panelColor
        )
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => EntryListViewModel(),
        child: const EntryListView(),
      )
    );
  }
}
