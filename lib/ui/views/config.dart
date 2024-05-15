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
  TextEditingController windowsHostTextController = TextEditingController();
  TextEditingController macHostTextController = TextEditingController();
  TextEditingController linuxHostTextController = TextEditingController();

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
      windowsHostTextController.text = config.windowsUrl;
      macHostTextController.text = config.macUrl;
      linuxHostTextController.text = config.linuxUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
      ),
      body: ListView(
        children: <Widget>[
          CustomInputTextWidget(
              width: 300,
              label: "Windows host",
              controller: windowsHostTextController),
          CustomInputTextWidget(
              width: 300, label: "Mac host", controller: macHostTextController),
          CustomInputTextWidget(
              width: 300,
              label: "Linux host",
              controller: linuxHostTextController),
          ElevatedButton(
            onPressed: _pickManifestDirectory,
            child: const Text('Select Output Manifest Directory'),
          ),
          CustomCheckBoxWidget(
              label: "Auto increment", controller: isAutoIncrementController),
          const SizedBox(height: 10),
          CustomCheckBoxWidget(
              label: "Smart manifest", controller: isSmartManifestController),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                final config = await ConfigManager.loadConfig();
                config.isAutoIncrement =
                    isAutoIncrementController.isChecked.value;
                config.isSmartManifest =
                    isSmartManifestController.isChecked.value;
                config.manifestDirPath = _manifestDir;
                config.versionDirPath = _versionDir;
                config.windowsUrl = windowsHostTextController.text;
                config.linuxUrl = linuxHostTextController.text;
                config.macUrl = macHostTextController.text;
                await ConfigManager.saveConfig(config);
                Navigator.of(context).pop();
              },
              child: const Text('Save')),
          const SizedBox(height: 10),
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
