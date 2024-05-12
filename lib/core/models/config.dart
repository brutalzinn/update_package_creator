import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConfigModel {
  String url;
  String manifestDirPath;
  String versionDirPath;
  bool isAutoIncrement;
  bool isSmartManifest;
  ConfigModel({
    required this.url,
    required this.manifestDirPath,
    required this.versionDirPath,
    required this.isAutoIncrement,
    required this.isSmartManifest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'manifestDirPath': manifestDirPath,
      'versionDirPath': versionDirPath,
      'isAutoIncrement': isAutoIncrement,
      'isSmartManifest': isSmartManifest,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      url: map['url'] as String,
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
