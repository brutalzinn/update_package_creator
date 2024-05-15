// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:update_package_creator/ui/controllers/checkbox_controller.dart';
import 'package:update_package_creator/ui/controllers/metadata_controller.dart';

import 'package:update_package_creator/ui/controllers/system_tabs_controller.dart';
import 'package:update_package_creator/ui/widgets/custom_checkbox.dart';
import 'package:update_package_creator/ui/widgets/custom_input_text.dart';
import 'package:update_package_creator/ui/widgets/custom_metadata.dart';

class SystemTab extends StatelessWidget {
  final MetadataController metadataController;
  final SystemTabsController systemTabsController;
  final CheckboxController isEnableOS = CheckboxController();
  final CheckboxController isEditMetadata = CheckboxController();

  final TextEditingController urlTextEditingController =
      TextEditingController();

  SystemTab(
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
    urlTextEditingController.text = systemTabsController.url.value;
    return SingleChildScrollView(
        child: Column(children: [
      CustomCheckBoxWidget(
          onChanged: (value) {
            systemTabsController.isEnabled.value = value!;
          },
          label: "Enable OS",
          controller: isEnableOS),
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
      CustomInputTextWidget(
          label: "Url",
          width: 500,
          controller: urlTextEditingController,
          onChanged: (value) {
            systemTabsController.url.value = value;
          }),
      CustomCheckBoxWidget(label: "Metadata", controller: isEditMetadata),
      ValueListenableBuilder<bool>(
        valueListenable: isEditMetadata.isChecked,
        builder: (BuildContext context, bool value, Widget? child) {
          return Visibility(
              visible: isEditMetadata.isChecked.value,
              child: CustomMetadataWidget(controller: metadataController));
        },
      )
    ]));
  }
}
