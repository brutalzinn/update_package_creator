import 'package:flutter/material.dart';

class MetadataController with ChangeNotifier {
  ValueNotifier<Map<String, dynamic>> metadata =
      ValueNotifier<Map<String, dynamic>>({});

  void setMetadata(Map<String, dynamic> source) {
    metadata.value = source;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
