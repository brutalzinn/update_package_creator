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
import 'package:update_package_creator/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/ui/widgets/custom_input_text.dart';
import 'package:update_package_creator/core/util.dart';

class ManifestEditor extends StatefulWidget {
  @override
  _ManifestEditorPageState createState() => _ManifestEditorPageState();
}

class _ManifestEditorPageState extends State<ManifestEditor> {
  TextEditingController versionTextController = TextEditingController();
  CheckboxController isAutoIncrementController = CheckboxController();
  late ConfigModel config;
  List<DataRow> cells = [];
  List<UpdateInfo> updates = [];

  ///@brutalzinn TODO: check how to refresh cells when sort is applied.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      config = await ConfigManager.loadConfig();
      final manifestFile = Util.getManifestFile(config);
      final manifest = await Util.readManifestFile(manifestFile);
      updates = manifest.updates;
      refresh();
    });
  }

  refresh() {
    cells.clear();
    for (var item in updates) {
      cells.add(
        DataRow(cells: [
          DataCell(
            Text(item.version),
            onTap: () async {
              final text = await Dialogs.showSimpleTextInput(
                  context, "Edit version",
                  initialText: item.version);

              if (text == null || Util.isValidVersion(text) == false) {
                await showOkAlertDialog(
                  context: context,
                  title: "Warning",
                  message: "wrong version format",
                );
                return;
              }
              final index = updates.indexOf(item);
              updates[index].version = text;
              refresh();
            },
          ),
          DataCell(
            Text(item.os.url),
            onTap: () async {
              final text = await Dialogs.showSimpleTextInput(
                  context, "Edit url",
                  initialText: item.os.url);
              if (text == null) {
                await showOkAlertDialog(
                  context: context,
                  title: "Warning",
                  message: "wrong url format",
                );
                return;
              }
              final index = updates.indexOf(item);
              updates[index].os.url = text;
              refresh();
            },
          ),
          DataCell(
            Text(item.os.name),
            onTap: () async {
              final text = await Dialogs.showSimpleTextInput(
                  context, "Edit OS name",
                  initialText: item.os.name);
              if (text == null) {
                await showOkAlertDialog(
                  context: context,
                  title: "Warning",
                  message: "wrong os name",
                );
                return;
              }
              final index = updates.indexOf(item);
              updates[index].os.url = text;
              refresh();
            },
          ),
          DataCell(IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.black.withOpacity(0.5),
                size: 18,
              ),
              onPressed: () async {
                final result = await showOkCancelAlertDialog(
                    context: context,
                    title: "Delete",
                    message: "Are you sure you want to delete this item?",
                    okLabel: "Yes",
                    cancelLabel: "No");
                if (result == OkCancelResult.ok) {
                  updates.remove(item);
                }
                refresh();
              }))
        ]),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manifest editor'),
      ),
      body: ListView(
        children: <Widget>[
          DataTable(columns: [
            DataColumn(
              label: const Text("Version"),
              onSort: (columnIndex, ascending) {
                if (!ascending) {
                  updates.sort(
                      (a, b) => Util.compareVersions(a.version, b.version));
                } else {
                  updates = updates.reversed.toList();
                }
                refresh();
              },
            ),
            const DataColumn(label: Text("Url")),
            const DataColumn(label: Text("OS")),
            const DataColumn(label: Text("Actions")),
          ], rows: cells),
          ElevatedButton(
              onPressed: () async {
                final manifestFile = Util.getManifestFile(config);
                final manifest = Manifest(updates: updates);
                await Util.writeManifestFile(manifestFile, manifest);
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
