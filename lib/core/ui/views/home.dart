import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:update_package_creator/core/models/manifest.dart';
import 'package:update_package_creator/core/models/update_info.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/core/ui/controllers/checkbox_controller.dart';
import 'package:update_package_creator/core/ui/views/config.dart';
import 'package:update_package_creator/core/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/core/ui/widgets/custom_input_text.dart';
import 'package:update_package_creator/core/util.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  String _sourceDirectory = 'test//input';
  String _outputDirectory = 'test//output';
  TextEditingController versionTextController = TextEditingController();
  CheckboxController checkboxController = CheckboxController();

  void initState() {
    super.initState();
    checkboxController.addListener(() {
      setState(() {});
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

  void _generateUpdatePackage() async {
    try {
      String manifestFile = 'manifest.json';
      String baseUrl = 'https://example.com/updates/';
      String versionFile = 'version.txt';
      String newVersion = await Util.readAndIncrementVersion(versionFile);
      String outputZipFile =
          p.join(_outputDirectory, "update_package_v$newVersion.zip");

      await Util.createUpdatePackage(_sourceDirectory, outputZipFile);

      Manifest manifest = await Util.readManifestFile(manifestFile);
      manifest.addUpdate(UpdateInfo(
          version: newVersion,
          url: '$baseUrl/update_package_v$newVersion.zip'));
      await Util.writeManifestFile(manifestFile, manifest);
      print('Update package created: $outputZipFile');
    } catch (e) {
      print('An error occurred: $e');
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text(
            'Update package would be generated from:\n$_sourceDirectory\nto:\n$_outputDirectory'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Package Creator'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              CustomInputText(
                  label: "Version", controller: versionTextController),
              CustomCheckbox(
                  label: "Auto increment", controller: checkboxController)
            ],
          ),
          ElevatedButton(
            onPressed: _pickSourceDirectory,
            child: Text('Select Source Directory'),
          ),
          Text('Selected: $_sourceDirectory'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickOutputDirectory,
            child: Text('Select Output Directory'),
          ),
          Text('Selected: $_outputDirectory'),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _generateUpdatePackage,
            child: Text('Generate Update Package'),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _openSettings,
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
