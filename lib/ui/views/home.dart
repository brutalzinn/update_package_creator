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
import 'package:update_package_creator/ui/controllers/metadata_controller.dart';
import 'package:update_package_creator/ui/controllers/system_tabs_controller.dart';
import 'package:update_package_creator/ui/dialogs/dialogs.dart';
import 'package:update_package_creator/ui/tabs/system.dart';
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
  SystemTabsController windowsTabController = SystemTabsController();
  SystemTabsController macTabController = SystemTabsController();
  SystemTabsController linuxTabController = SystemTabsController();
  MetadataController windowsMetadataController = MetadataController();
  MetadataController linuxMetadataController = MetadataController();
  MetadataController macMetadataController = MetadataController();

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
          os: OsInfo("win", '$baseUrl/update_package_v$newVersion.zip',
              windowsMetadataController.metadata.value),
          metadata: {},
          version: newVersion,
        ));
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
      body: DefaultTabController(
        length: 3,
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                CustomInputTextWidget(
                    label: "Version", controller: versionTextController),
                CustomCheckBoxWidget(
                    label: "Auto increment",
                    controller: isAutoIncrementController),
              ],
            ),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.window), child: Text("Windows")),
                Tab(icon: Icon(Icons.apple), child: Text("Mac OS")),
                Tab(
                    icon: Icon(Icons.admin_panel_settings_outlined),
                    child: Text("Linux")),
              ],
            ),
            SizedBox(
              height: 350,
              child: TabBarView(children: [
                Center(
                    child: SystemTab(
                  systemTabsController: windowsTabController,
                  metadataController: windowsMetadataController,
                )),
                Center(
                    child: SystemTab(
                  systemTabsController: linuxTabController,
                  metadataController: linuxMetadataController,
                )),
                Center(
                    child: SystemTab(
                  systemTabsController: macTabController,
                  metadataController: macMetadataController,
                )),
              ]),
            ),
            // const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _generateUpdatePackage,
              child: const Text('Generate Update Package'),
            ),
            // const SizedBox(height: 200),
            ElevatedButton(
              onPressed: _openManifest,
              child: const Text('Manifest editor'),
            ),
            // const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _openSettings,
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
