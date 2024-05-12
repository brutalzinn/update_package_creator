import 'package:flutter/material.dart';

class CheckboxController with ChangeNotifier {
  ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);

  void onChanged(bool? checked) {
    isChecked.value = checked!;
    notifyListeners();
  }
}
