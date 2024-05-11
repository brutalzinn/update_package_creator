import 'package:flutter/material.dart';
import 'package:update_package_creator/core/ui/controllers/checkbox_controller.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final CheckboxController controller;
  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        label,
        style: const TextStyle(fontSize: 18.0, color: Colors.black),
      ),
      SizedBox(
        width: 150,
        child: Checkbox(
          value: controller.isChecked,
          onChanged: controller.onChanged,
        ),
      ),
    ]);
  }
}
