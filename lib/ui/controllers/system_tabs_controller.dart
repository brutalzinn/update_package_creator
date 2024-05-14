import 'package:flutter/material.dart';

class SystemTabsController with ChangeNotifier {
  ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);

  ValueNotifier<String> url = ValueNotifier<String>("");

  ValueNotifier<String> outputDirectory = ValueNotifier<String>("");

  ValueNotifier<String> inputDirectory = ValueNotifier<String>("");

  ValueNotifier<Map<String, dynamic>> metadata =
      ValueNotifier<Map<String, dynamic>>({});
}
