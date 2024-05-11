import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:update_package_creator/core/models/manifest.dart';
import 'package:update_package_creator/core/models/update_info.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/core/ui/controllers/checkbox_controller.dart';
import 'package:update_package_creator/core/ui/views/home.dart';
import 'package:update_package_creator/core/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/core/ui/widgets/custom_input_text.dart';

import 'core/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Package Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
