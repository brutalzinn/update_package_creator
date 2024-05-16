// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OsInfo {
  String name;
  String url;
  Map<String, dynamic>? metadata;

  OsInfo(this.name, this.url, this.metadata);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
      'metadata': metadata,
    };
  }

  factory OsInfo.fromMap(Map<String, dynamic> map) {
    return OsInfo(
      map['name'] as String,
      map['url'] as String,
      map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OsInfo.fromJson(String source) =>
      OsInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UpdateInfo {
  String version;
  OsInfo? windowsOS;
  OsInfo? macOS;
  OsInfo? linuxOS;

  Map<String, dynamic>? metadata;
  UpdateInfo({
    required this.version,
    this.windowsOS,
    this.macOS,
    this.linuxOS,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'windowsOS': windowsOS?.toMap(),
      'macOS': macOS?.toMap(),
      'linuxOS': linuxOS?.toMap(),
      'metadata': metadata,
    };
  }

  factory UpdateInfo.fromMap(Map<String, dynamic> map) {
    return UpdateInfo(
      version: map['version'] as String,
      windowsOS: map['windowsOS'] != null
          ? OsInfo.fromMap(map['windowsOS'] as Map<String, dynamic>)
          : null,
      macOS: map['macOS'] != null
          ? OsInfo.fromMap(map['macOS'] as Map<String, dynamic>)
          : null,
      linuxOS: map['linuxOS'] != null
          ? OsInfo.fromMap(map['linuxOS'] as Map<String, dynamic>)
          : null,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateInfo.fromJson(String source) =>
      UpdateInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  OsInfo getOsInfo() {
    if (macOS != null) {
      return macOS!;
    }
    if (linuxOS != null) {
      return linuxOS!;
    }

    return windowsOS!;
  }
}
