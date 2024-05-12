import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:update_package_creator/core/config_manager.dart';
import 'package:update_package_creator/core/models/config.dart';
import 'package:update_package_creator/core/models/manifest.dart';
import 'package:update_package_creator/core/models/update_info.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/ui/controllers/checkbox_controller.dart';
import 'package:update_package_creator/ui/dialogs/dialogs.dart';
import 'package:update_package_creator/ui/views/config.dart';
import 'package:update_package_creator/ui/views/manifest.dart';
import 'package:update_package_creator/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/ui/widgets/custom_input_text.dart';
import 'package:update_package_creator/core/util.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  String manifestFile = "";
  String baseUrl = "";
  String versionFile = "";
  String _sourceDirectory = 'test//input';
  String _outputDirectory = 'test//output';
  TextEditingController versionTextController = TextEditingController();
  CheckboxController isAutoIncrementController = CheckboxController();
  late ConfigModel config;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      config = await ConfigManager.loadConfig();
      versionTextController.text = await Util.readVersion(versionFile);
      isAutoIncrementController.isChecked.value = config.isAutoIncrement;
      baseUrl = config.url;
      manifestFile = Util.getManifestFile(config);
      versionFile = Util.getVersionFile(config);
    });
  }

  void _pickSourceDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _sourceDirectory = selectedDirectory;
      });
    }
  }

  void _pickOutputDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _outputDirectory = selectedDirectory;
      });
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Config()),
    );
  }

  void _openManifest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManifestEditor()),
    );
  }

  void _generateUpdatePackage() async {
    try {
      String newVersion = versionTextController.text;
      if (isAutoIncrementController.isChecked.value) {
        newVersion = await Util.readAndIncrementVersion(versionFile);
      }
      String outputZipFile =
          p.join(_outputDirectory, "update_package_v$newVersion.zip");
      await Util.createUpdatePackage(_sourceDirectory, outputZipFile);
      Manifest manifest = Manifest(updates: []);
      if (config.isSmartManifest) {
        manifest = await Util.readManifestFile(manifestFile);
        manifest.addUpdate(UpdateInfo(
            version: newVersion,
            url: '$baseUrl/update_package_v$newVersion.zip'));
      }
      await Util.writeManifestFile(manifestFile, manifest);
      Dialogs.showSimpleAlert(context, "Sucess",
          message:
              " 'Update package would be generated from:\n$_sourceDirectory\nto:\n$_outputDirectory'");
    } catch (e) {
      /// todo: add internalization support to keep messages consistence
      Dialogs.showSimpleAlert(context, "Error",
          message:
              "Ring around the rosies... something is broken and the fault is mine...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Package Creator'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: [
              CustomInputText(
                  label: "Version", controller: versionTextController),
              CustomCheckbox(
                  label: "Auto increment",
                  controller: isAutoIncrementController),
            ],
          ),
          ElevatedButton(
            onPressed: _pickSourceDirectory,
            child: const Text('Select Source Directory'),
          ),
          Text('Selected: $_sourceDirectory'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickOutputDirectory,
            child: const Text('Select Output Directory'),
          ),
          Text('Selected: $_outputDirectory'),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _generateUpdatePackage,
            child: const Text('Generate Update Package'),
          ),
          const SizedBox(height: 200),
          ElevatedButton(
            onPressed: _openManifest,
            child: const Text('Manifest editor'),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _openSettings,
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
