import 'package:flutter/material.dart';

class CustomMetadataWidget extends StatefulWidget {
  @override
  _CustomMetadataWidgetState createState() => _CustomMetadataWidgetState();
}

class _CustomMetadataWidgetState extends State<CustomMetadataWidget> {
  final Map<String, dynamic> _metadata = {};
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  void _addOrUpdateMetadata() {
    String key = _keyController.text;
    dynamic value = _valueController.text;
    setState(() {
      _metadata[key] = value;
    });
    _keyController.clear();
    _valueController.clear();
  }

  void _deleteMetadata(String key) {
    setState(() {
      _metadata.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _keyController,
          decoration: const InputDecoration(
            labelText: 'Key',
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: _addOrUpdateMetadata,
          child: const Text('Add/Update Metadata'),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _metadata.length,
          itemBuilder: (context, index) {
            String key = _metadata.keys.elementAt(index);
            return ListTile(
              title: Text('$key: ${_metadata[key]}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteMetadata(key),
              ),
            );
          },
        ),
      ],
    );
  }
}
