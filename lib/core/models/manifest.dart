// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:update_package_creator/core/models/update_info.dart';

class Manifest {
  List<UpdateInfo> updates;

  Manifest({
    required this.updates,
  });

  void addUpdate(UpdateInfo updateInfo) {
    updates.add(updateInfo);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'updates': updates.map((x) => x.toMap()).toList(),
    };
  }

  factory Manifest.fromMap(Map<String, dynamic> map) {
    return Manifest(
      updates: List<UpdateInfo>.from(
        (map['updates'] as List).map<UpdateInfo>(
          (x) => UpdateInfo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Manifest.fromJson(String source) =>
      Manifest.fromMap(json.decode(source) as Map<String, dynamic>);
}
