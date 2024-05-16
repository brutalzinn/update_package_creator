import 'dart:convert';
import 'dart:io';

class Translation {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'hello': 'Hello',
      'world': 'World',
    },
    'es': {
      'hello': 'Hola',
      'world': 'Mundo',
    },
  };

  ///Load translations
  static Future<void> init(String sourceDir) async {
    Directory dir = Directory(sourceDir);
    if (!await dir.exists()) {
      await dir.create();
      // throw Exception("Source directory does not exist.");
    }
    List<File> files = await dir
        .list(recursive: true)
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
    for (File file in files) {
      String content = await file.readAsString();
      final data = Map.from(jsonDecode(content));

      for (String locale in data.keys) {
        if (_localizedValues[locale] == null) {
          _localizedValues[locale] = {};
        }
        for (String key in data[locale]) {
          _localizedValues[locale] = data[locale][key];
        }
      }
    }
  }

  static String t(String key, {String locale = 'en'}) {
    return _localizedValues[locale]?[key] ?? "NO_TRANSLATION_FOUND";
  }
}
