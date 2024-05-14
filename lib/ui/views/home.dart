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
  TextEditingController versionTextController = TextEditingController();
  CheckboxController isAutoIncrementController = CheckboxController();
  SystemTabsController windowsTabController = SystemTabsController();
  SystemTabsController macTabController = SystemTabsController();
  SystemTabsController linuxTabController = SystemTabsController();
  MetadataController windowsMetadataController = MetadataController();
  MetadataController linuxMetadataController = MetadataController();
  MetadataController macMetadataController = MetadataController();
  String _sourceDirectory = "";
  String _outputDirectory = "";
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

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Config()),
    );
  }

  void _openManifest() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ManifestEditor()),
    // );
  }

  void _generateUpdatePackage() async {
    try {
      String newVersion = versionTextController.text;
      // if (isAutoIncrementController.isChecked.value) {
      //   newVersion = await Util.readVersion(versionFile);
      // }
      if (windowsTabController.isEnabled.value) {
        _sourceDirectory = windowsTabController.inputDirectory.value;
        _outputDirectory = windowsTabController.outputDirectory.value;
      }
      if (linuxTabController.isEnabled.value) {
        _sourceDirectory = linuxTabController.inputDirectory.value;
        _outputDirectory = linuxTabController.outputDirectory.value;
      }
      if (macTabController.isEnabled.value) {
        _sourceDirectory = macTabController.inputDirectory.value;
        _outputDirectory = macTabController.outputDirectory.value;
      }
      String outputZipFile =
          p.join(_outputDirectory, "update_package_v$newVersion.zip");
      await Util.createUpdatePackage(_sourceDirectory, outputZipFile);
      List<OsInfo> osInfo = [];

      ///todo: add adjuement when something failes.. we need a rollback
      if (config.isSmartManifest) {
        if (windowsTabController.isEnabled.value) {
          osInfo.add(
            OsInfo("win", '$baseUrl/update_package_v$newVersion.zip',
                windowsMetadataController.metadata.value),
          );
        }
        if (macTabController.isEnabled.value) {
          osInfo.add(
            OsInfo("macos", '$baseUrl/update_package_v$newVersion.zip',
                macTabController.metadata.value),
          );
        }
        if (linuxTabController.isEnabled.value) {
          osInfo.add(
            OsInfo("linux", '$baseUrl/update_package_v$newVersion.zip',
                linuxTabController.metadata.value),
          );
        }
      }
      final manifest = await Util.readManifestFile(manifestFile);
      manifest.addUpdate(UpdateInfo(
        os: osInfo,
        metadata: {},
        version: newVersion,
      ));
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _generateUpdatePackage,
              child: const Text('Generate Update Package'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _openManifest,
              child: const Text('Manifest editor'),
            ),
            const SizedBox(height: 10),
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
