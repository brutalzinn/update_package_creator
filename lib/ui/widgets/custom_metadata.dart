import 'package:flutter/material.dart';
import 'package:update_package_creator/ui/controllers/metadata_controller.dart';

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
  GlobalKey<_CustomMetadataWidgetState> _myKey =
      GlobalKey(); // We declare a key here

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
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                  controller: _keyController,
                  decoration: const InputDecoration(
                    labelText: 'Key',
                    border: OutlineInputBorder(),
                  )),
            ),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addOrUpdateMetadata,
              child: const Text('Add/Update Metadata'),
            ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 35.0,
            maxHeight: 160.0,
          ),
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
