import 'package:flutter/material.dart';
import 'package:update_package_creator/ui/controllers/metadata_controller.dart';
import 'package:update_package_creator/ui/widgets/custom_input_text.dart';

class CustomMetadataWidget extends StatefulWidget {
  final MetadataController controller;

  const CustomMetadataWidget({super.key, required this.controller});

  @override
  _CustomMetadataWidgetState createState() => _CustomMetadataWidgetState();
}

// class CustomMetadataWidget extends StatelessWidget {
class _CustomMetadataWidgetState extends State<CustomMetadataWidget> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  void _addOrUpdateMetadata() {
    String key = _keyController.text;
    dynamic value = _valueController.text;
    widget.controller.metadata.value[key] = value;
    _keyController.clear();
    _valueController.clear();
    setState(() {});
  }

  void _deleteMetadata(String key) {
    widget.controller.metadata.value.remove(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInputTextWidget(label: "key", controller: _keyController),
            CustomInputTextWidget(label: "value", controller: _valueController),
            ElevatedButton(
              onPressed: _addOrUpdateMetadata,
              child: const Text('Add/Update Metadata'),
            ),
          ],
        ),
        Container(
          color: Colors.black12,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.controller.metadata.value.length,
            itemBuilder: (context, index) {
              String key =
                  widget.controller.metadata.value.keys.elementAt(index);
              return ListTile(
                title: Text('$key: ${widget.controller.metadata.value[key]}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteMetadata(key),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
