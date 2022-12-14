import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:jot_down/styles.dart';
import 'package:jot_down/view_models/entry_list_view_model.dart';

class NewEntryWidget extends StatelessWidget {
  // The view movel used throughout the app
  final EntryListViewModel vm;
  // Updates the view model when changes are made
  final Function({String title, String keyword, bool trash})? updateView;
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
      cursorColor: tagColor,
      controller: controller,
      scrollPadding: const EdgeInsets.all(5.0),
      decoratedStyle: bodyAccentText,
      basicStyle: bodyText,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 10,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          contentPadding: const EdgeInsets.only(left: 10),
          hintText: "I want to remember...",
          suffixIcon: IconButton(
              color: tagColor,
              onPressed: () {
                vm.addEntry(controller.text).then((value) =>
                    updateView!(title: 'Home', keyword: '', trash: false));
                FocusManager.instance.primaryFocus?.unfocus();
                controller.clear();
              },
              icon: const Icon(Icons.send))),
    );
  }
}
