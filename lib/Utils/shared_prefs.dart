import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _key = "processed_files";

  static Future<void> addProcessedFile(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> files = prefs.getStringList(_key) ?? [];

    String newFilePath = filePath;
    int counter = 1;

    // Check if file already exists, and keep incrementing until a unique name is found
    while (files.contains(newFilePath)) {
      newFilePath = '$filePath$counter';
      counter++;
    }

    files.add(newFilePath);
    await prefs.setStringList(_key, files);
  }


  static Future<List<String>> getProcessedFiles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> clearProcessedFiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

}
