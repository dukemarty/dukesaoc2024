import 'dart:convert';
import 'dart:io';

Future<String> readSingleLine(String filename) async {
  String text = "";
  try {
    final File file = File(filename);
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}

Future<List<String>> readLines(String filename) async {

  final file = File(filename);
  Stream<List<int>> inputStream = file.openRead();

  var res = inputStream
    .transform(utf8.decoder)       // Decode bytes to UTF-8.
    .transform(LineSplitter()); // Convert stream to individual lines.

  return res.toList();
}
