import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';
import 'package:jot_down/entry_data.dart';

class NewEntryWidget extends StatelessWidget {
  // The view movel used throughout the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function(
      {String title,
      String keyword,
      DateTime? start,
      DateTime? end,
      EntryListViewModel vm})? updateEntries;
  // The controller that tracks input throughout the app
  final TextEditingController controller;

  const NewEntryWidget(
      {required this.updateEntries,
      required this.vm,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return HashTagTextField(
      controller: controller,
      scrollPadding: const EdgeInsets.all(5.0),
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
          ),
          contentPadding: EdgeInsets.only(left: 10),
          hintText: "Create Entry",
          suffixIcon: IconButton(
              onPressed: () {
                vm
                    .addEntry(controller.text)
                    .then((value) => updateEntries!(title: 'Home', vm: vm));
                FocusManager.instance.primaryFocus?.unfocus();
                controller.clear();
              },
              icon: const Icon(Icons.send))),
      decoratedStyle: const TextStyle(fontSize: 20, color: Colors.blue),
      basicStyle: const TextStyle(fontSize: 20, color: Colors.black),
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  }
}
