import 'package:flutter/material.dart';

class SystemTabsController with ChangeNotifier {
  ValueNotifier<String> outputDirectory = ValueNotifier<String>("");

  ValueNotifier<String> inputDirectory = ValueNotifier<String>("");

  void setOutputDirectory(String source) {
    outputDirectory.value = source;
    notifyListeners();
  }

  void setInputDirectory(String source) {
    inputDirectory.value = source;
    notifyListeners();
  }

  // ValueNotifier<OsInfo> os = ValueNotifier<OsInfo>(OsInfo("windows", "", {}));
  // ValueNotifier<String> url = ValueNotifier<String>("");

  // SystemTabsController(String name,
  //     {Map<String, dynamic> metadata = const {}}) {
  //   os.value = OsInfo(name, "", metadata);
  // }
  // void setUrl(String value) {
  //   url.value = value;
  //   notifyListeners();
  // }

  // ///operational system
  // void setOs(OsInfo value) {
  //   os.value = value;
  //   notifyListeners();
  // }
}
