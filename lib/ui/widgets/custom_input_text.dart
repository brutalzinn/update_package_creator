import 'package:flutter/material.dart';

class CustomInputTextWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final double width;
  const CustomInputTextWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.onChanged,
      this.width = 150});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        label,
        style: const TextStyle(fontSize: 18.0, color: Colors.black),
      ),
      SizedBox(
        width: width,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ]);
  }
}
