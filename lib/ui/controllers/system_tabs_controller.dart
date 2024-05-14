import 'package:flutter/material.dart';

class SystemTabsController with ChangeNotifier {
  ValueNotifier<String> outputDirectory = ValueNotifier<String>("");

  ValueNotifier<String> inputDirectory = ValueNotifier<String>("");

  ValueNotifier<Map<String, dynamic>> metadata =
      ValueNotifier<Map<String, dynamic>>({});

  void setOutputDirectory(String source) {
    outputDirectory.value = source;
    notifyListeners();
  }

  void setInputDirectory(String source) {
    inputDirectory.value = source;
    notifyListeners();
  }

  void setMetadata(Map<String, dynamic> source) {
    metadata.value = source;
    notifyListeners();
  }
}
