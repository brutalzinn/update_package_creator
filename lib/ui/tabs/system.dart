// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:update_package_creator/ui/controllers/metadata_controller.dart';

import 'package:update_package_creator/ui/controllers/system_tabs_controller.dart';
import 'package:update_package_creator/ui/widgets/custom_metadata.dart';

class SystemTab extends StatelessWidget {
  final MetadataController metadataController;
  final SystemTabsController systemTabsController;
  const SystemTab(
      {super.key,
      required this.systemTabsController,
      required this.metadataController});

  void _pickInputDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      systemTabsController.inputDirectory.value = selectedDirectory;
    }
  }

  void _pickOutputDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      systemTabsController.outputDirectory.value = selectedDirectory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickInputDirectory,
          child: const Text('Select Source Directory'),
        ),
        Text('Selected: ${systemTabsController.outputDirectory.value}'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _pickOutputDirectory,
          child: const Text('Select Output Directory'),
        ),
        CustomMetadataWidget(controller: metadataController)
      ],
    );
  }
}
