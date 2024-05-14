import 'package:flutter/material.dart';
import 'package:update_package_creator/ui/controllers/checkbox_controller.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final String label;
  final CheckboxController controller;
  final Function(bool?)? onChanged;
  const CustomCheckBoxWidget(
      {Key? key, required this.label, required this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        label,
        style: const TextStyle(fontSize: 18.0, color: Colors.black),
      ),
      SizedBox(
        width: 150,
        child: ValueListenableBuilder<bool>(
            valueListenable: controller.isChecked,
            builder: (context, value, _) {
              return Checkbox(
                value: controller.isChecked.value,
                onChanged: (value) {
                  controller.onChanged(value);
                  if (onChanged != null) {
                    onChanged!(value);
                  }
                },
              );
            }),
      ),
    ]);
  }
}
