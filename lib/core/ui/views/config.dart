import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:update_package_creator/core/config_manager.dart';
import 'package:update_package_creator/core/models/manifest.dart';
import 'package:update_package_creator/core/models/update_info.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/core/ui/controllers/checkbox_controller.dart';
import 'package:update_package_creator/core/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/core/ui/widgets/custom_input_text.dart';
import 'package:update_package_creator/core/util.dart';

class Config extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<Config> {
  TextEditingController urlHostTextController = TextEditingController();
  TextEditingController versionTextController = TextEditingController();
  CheckboxController isAutoIncrementController = CheckboxController();
  CheckboxController isSmartManifestController = CheckboxController();

  String _manifestDir = '';

  void _pickManifestDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _manifestDir = selectedDirectory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
      ),
      body: Column(
        children: <Widget>[
          CustomInputText(label: "Url host", controller: versionTextController),
          ElevatedButton(
            onPressed: _pickManifestDirectory,
            child: Text('Select Output Directory'),
          ),
          CustomCheckbox(
              label: "Auto increment", controller: isAutoIncrementController),
          CustomCheckbox(
              label: "Smart manifest", controller: isSmartManifestController),
          ElevatedButton(
              onPressed: () async {
                final config = await ConfigManager.loadConfig();
                config.isAutoIncrement = isAutoIncrementController.isChecked;
                config.isSmartManifest = isSmartManifestController.isChecked;
                config.manifestPath = _manifestDir;
                config.url = urlHostTextController.text;
                await ConfigManager.saveConfig(config);
              },
              child: Text('Save')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'),
          ),
        ],
      ),
    );
  }
}
