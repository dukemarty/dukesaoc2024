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

