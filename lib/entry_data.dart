import 'dart:convert';
import 'package:jot_down/models/entry.dart';
import 'package:jot_down/view_models/entry_view_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

class EntryData {
  var uuid = const Uuid();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/entry_data.json');
  }

  Future<List<Entry>> fetchEntries() async {
    try {
      final file = await _localFile;
      final fileContents = await file.readAsString();
      final Iterable json = jsonDecode(fileContents);
      return json.map((entry) => Entry.fromJson(entry)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Entry> addEntry(String content) async {
    Map<String, dynamic> entryJson = await writeEntry(content);
    return Entry.fromJson(entryJson);
  }

  Future<Map<String, dynamic>> writeEntry(String content) async {
    var json = [];

    final file = await _localFile;
    if (await file.exists()) {
      final fileContents = await file.readAsString();
      json = jsonDecode(fileContents);
    }

    Map<String, dynamic> newEntry = <String, dynamic>{};
    newEntry['id'] = uuid.v1();
    newEntry['time'] = DateTime.now().toIso8601String();
    newEntry['content'] = content;
    newEntry['trash'] = false;

    json.add(newEntry);
    await file.writeAsString(jsonEncode(json));
    return newEntry;
  }

  Future<void> editEntry(
      String id, String content, DateTime time, bool trash) async {
    var json = [];

    final file = await _localFile;
    if (await file.exists()) {
      final fileContents = await file.readAsString();
      json = jsonDecode(fileContents);
    }

    var entry = json.firstWhere((element) => element['id'] == id);
    entry['content'] = content;
    entry['trash'] = trash;
    entry['time'] = time.toIso8601String();
    await file.writeAsString(jsonEncode(json));
  }

  Future<bool> deleteEntry(String id) async {
    var json = [];

    final file = await _localFile;
    if (await file.exists()) {
      final fileContents = await file.readAsString();
      json = jsonDecode(fileContents);
    }

    bool success = json.remove(json.firstWhereOrNull((entry) => entry['id'] == id));
    await file.writeAsString(jsonEncode(json));
    return success;
  }

}
