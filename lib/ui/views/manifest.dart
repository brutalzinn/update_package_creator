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
import 'package:update_package_creator/ui/dialogs/dialogs.dart';
import 'package:update_package_creator/ui/views/config.dart';
import 'package:update_package_creator/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/ui/widgets/custom_input_text.dart';
import 'package:update_package_creator/core/modules/manifest/manifest_util.dart';

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
      final manifestFile = ManifestUtil.getManifestFile(config);
      final manifest = await ManifestUtil.readManifestFile(manifestFile);
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

              if (text == null || ManifestUtil.isValidVersion(text) == false) {
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
          DataCell(Text(
              ("${item.windowsOS?.name ?? ""} ${item.macOS?.name ?? ""} ${item.linuxOS?.name ?? ""}"))),
          // DataCell(
          //   Text(item.getOsInfo().url),
          //   onTap: () async {
          //     final text = await Dialogs.showSimpleTextInput(
          //         context, "Edit url",
          //         initialText: item.getOsInfo().url);
          //     if (text == null) {
          //       await showOkAlertDialog(
          //         context: context,
          //         title: "Warning",
          //         message: "wrong url format",
          //       );
          //       return;
          //     }
          //     final index = updates.indexOf(item);
          //     (updates[index]).getOsInfo().url = text;
          //     refresh();
          //   },
          // ),
          DataCell(Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black.withOpacity(0.5),
                    size: 18,
                  ),
                  onPressed: () async {
                    final actions =
                        await showModalActionSheet(context: context, actions: [
                      const SheetAction(label: "windows", key: "windows"),
                      const SheetAction(label: "linux", key: "linux"),
                      const SheetAction(label: "mac", key: "mac"),
                    ]);
                    final index = updates.indexOf(item);
                    final url = actions == "windows"
                        ? item.windowsOS?.url
                        : actions == "linux"
                            ? item.linuxOS?.url
                            : item.macOS?.url;

                    final text = await Dialogs.showSimpleTextInput(
                        context, "Edit url",
                        initialText: url ?? "");
                    if (text == null) {
                      await showOkAlertDialog(
                        context: context,
                        title: "Warning",
                        message: "wrong url format",
                      );
                      return;
                    }
                    switch (actions) {
                      case "windows":
                        updates[index].windowsOS!.url = text;
                        break;
                      case "linux":
                        updates[index].linuxOS!.url = text;
                        break;
                      case "mac":
                        updates[index].macOS!.url = text;
                        break;
                    }
                    refresh();
                  }),
              IconButton(
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
                  }),
            ],
          ))
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
                  updates.sort((a, b) =>
                      ManifestUtil.compareVersions(a.version, b.version));
                } else {
                  updates = updates.reversed.toList();
                }
                refresh();
              },
            ),
            const DataColumn(label: Text("OS")),
            const DataColumn(label: Text("Actions")),
          ], rows: cells),
          ElevatedButton(
              onPressed: () async {
                final manifestFile = ManifestUtil.getManifestFile(config);
                final manifest = Manifest(updates: updates);
                await ManifestUtil.writeManifestFile(manifestFile, manifest);
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
