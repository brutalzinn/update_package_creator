import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConfigModel {
  String windowsUrl;
  String macUrl;
  String linuxUrl;

  String manifestDirPath;
  String versionDirPath;
  bool isAutoIncrement;
  bool isSmartManifest;
  ConfigModel({
    this.windowsUrl = "",
    this.macUrl = "",
    this.linuxUrl = "",
    required this.manifestDirPath,
    required this.versionDirPath,
    required this.isAutoIncrement,
    required this.isSmartManifest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'windowsUrl': windowsUrl,
      'macUrl': macUrl,
      'linuxUrl': linuxUrl,
      'manifestDirPath': manifestDirPath,
      'versionDirPath': versionDirPath,
      'isAutoIncrement': isAutoIncrement,
      'isSmartManifest': isSmartManifest,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      windowsUrl: map['windowsUrl'] as String,
      macUrl: map['macUrl'] as String,
      linuxUrl: map['linuxUrl'] as String,
      manifestDirPath: map['manifestDirPath'] as String,
      versionDirPath: map['versionDirPath'] as String,
      isAutoIncrement: map['isAutoIncrement'] as bool,
      isSmartManifest: map['isSmartManifest'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
