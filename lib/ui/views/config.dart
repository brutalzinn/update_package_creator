import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:update_package_creator/core/config_manager.dart';
import 'package:update_package_creator/core/models/config.dart';
import 'package:update_package_creator/core/models/manifest.dart';
import 'package:update_package_creator/core/models/update_info.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/ui/controllers/checkbox_controller.dart';
import 'package:update_package_creator/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/ui/widgets/custom_input_text.dart';
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
  late ConfigModel config;

  String _manifestDir = '';
  String _versionDir = '';

  void _pickManifestDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _manifestDir = selectedDirectory;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      config = await ConfigManager.loadConfig();
      isSmartManifestController.onChanged(config.isSmartManifest);
      isAutoIncrementController.onChanged(config.isAutoIncrement);
      versionTextController.text = config.versionDirPath;
      urlHostTextController.text = config.url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
      ),
      body: Column(
        children: <Widget>[
          CustomInputText(label: "Url host", controller: urlHostTextController),
          ElevatedButton(
            onPressed: _pickManifestDirectory,
            child: const Text('Select Output Manifest Directory'),
          ),
          CustomCheckbox(
              label: "Auto increment", controller: isAutoIncrementController),
          CustomCheckbox(
              label: "Smart manifest", controller: isSmartManifestController),
          ElevatedButton(
              onPressed: () async {
                final config = await ConfigManager.loadConfig();
                config.isAutoIncrement =
                    isAutoIncrementController.isChecked.value;
                config.isSmartManifest =
                    isSmartManifestController.isChecked.value;
                config.manifestDirPath = _manifestDir;
                config.versionDirPath = _versionDir;
                config.url = urlHostTextController.text;
                await ConfigManager.saveConfig(config);
                Navigator.of(context).pop();
              },
              child: const Text('Save')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }
}
