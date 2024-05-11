import 'package:flutter/material.dart';

class CheckboxController extends ChangeNotifier {
  bool isChecked = false;

  void toggle() {
    isChecked = !isChecked;
    notifyListeners();
  }

  void onChanged(bool? checked) {
    isChecked = checked!;
    notifyListeners();
  }
}
