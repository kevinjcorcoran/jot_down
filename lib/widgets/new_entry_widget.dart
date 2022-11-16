import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';

class NewEntryWidget extends StatelessWidget {
  // The view movel used throughout the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function({String title, String keyword})? updateView;
  // The controller that tracks input throughout the app
  final TextEditingController controller;

  const NewEntryWidget(
      {super.key,
      required this.updateView,
      required this.vm,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return HashTagTextField(
      controller: controller,
      scrollPadding: const EdgeInsets.all(5.0),
      decoratedStyle: const TextStyle(fontSize: 20, color: Colors.blue),
      basicStyle: const TextStyle(fontSize: 20, color: Colors.black),
      keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
          ),
          contentPadding: const EdgeInsets.only(left: 10),
          hintText: "Create Entry",
          suffixIcon: IconButton(
              onPressed: () {
                vm
                    .addEntry(controller.text)
                    .then((value) => updateView!(title: 'Home'));
                FocusManager.instance.primaryFocus?.unfocus();
                controller.clear();
              },
              icon: const Icon(Icons.send))),
    );
  }
}
