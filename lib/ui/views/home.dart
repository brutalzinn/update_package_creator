import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:update_package_creator/core/config_manager.dart';
import 'package:update_package_creator/core/modules/manifest/models/config.dart';
import 'package:update_package_creator/core/modules/manifest/models/manifest.dart';
import 'package:update_package_creator/core/modules/manifest/models/update_info.dart';
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
import 'package:update_package_creator/core/modules/manifest/manifest_util.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  String manifestFile = "";
  // String baseUrl = "";
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
      versionTextController.text = await ManifestUtil.readVersion(versionFile);
      isAutoIncrementController.isChecked.value = config.isAutoIncrement;

      windowsTabController.url.value = config.windowsUrl;
      linuxTabController.url.value = config.linuxUrl;
      macTabController.url.value = config.macUrl;

      manifestFile = ManifestUtil.getManifestFile(config);
      versionFile = ManifestUtil.getVersionFile(config);
      setState(() {});
    });
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
      String _baseUrl = "";
      // if (isAutoIncrementController.isChecked.value) {
      //   newVersion = await Util.readVersion(versionFile);
      // }
      if (windowsTabController.isEnabled.value) {
        _sourceDirectory = windowsTabController.inputDirectory.value;
        _outputDirectory = windowsTabController.outputDirectory.value;
        _baseUrl = windowsTabController.url.value;
      }
      if (linuxTabController.isEnabled.value) {
        _sourceDirectory = linuxTabController.inputDirectory.value;
        _outputDirectory = linuxTabController.outputDirectory.value;
        _baseUrl = linuxTabController.url.value;
      }
      if (macTabController.isEnabled.value) {
        _sourceDirectory = macTabController.inputDirectory.value;
        _outputDirectory = macTabController.outputDirectory.value;
        _baseUrl = macTabController.url.value;
      }
      String outputZipFile =
          p.join(_outputDirectory, "update_package_v$newVersion.zip");
      await ManifestUtil.createUpdatePackage(_sourceDirectory, outputZipFile);

      OsInfo? windows;
      OsInfo? linux;
      OsInfo? mac;

      if (windowsTabController.isEnabled.value) {
        windows = OsInfo("win", '$_baseUrl/update_package_v$newVersion.zip',
            windowsMetadataController.metadata.value);
      }
      if (macTabController.isEnabled.value) {
        mac = OsInfo("macos", '$_baseUrl/update_package_v$newVersion.zip',
            macMetadataController.metadata.value);
      }
      if (linuxTabController.isEnabled.value) {
        linux = OsInfo("linux", '$_baseUrl/update_package_v$newVersion.zip',
            linuxMetadataController.metadata.value);
      }
      Manifest manifest = Manifest(updates: []);
      if (config.isSmartManifest) {
        manifest = await ManifestUtil.readManifestFile(manifestFile);
      }
      manifest.addUpdate(UpdateInfo(
        windowsOS: windows,
        macOS: mac,
        linuxOS: linux,
        metadata: {},
        version: newVersion,
      ));
      await ManifestUtil.writeManifestFile(manifestFile, manifest);
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                Tab(
                    icon: Icon(Icons.admin_panel_settings_outlined),
                    child: Text("Linux")),
                Tab(icon: Icon(Icons.apple), child: Text("Mac OS"))
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
