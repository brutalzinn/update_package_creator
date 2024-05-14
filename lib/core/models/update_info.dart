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
  List<OsInfo> os;
  Map<String, dynamic>? metadata;

  UpdateInfo({
    required this.version,
    required this.os,
    required this.metadata,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'os': os.map((x) => x.toMap()).toList(),
      'metadata': metadata,
    };
  }

  factory UpdateInfo.fromMap(Map<String, dynamic> map) {
    return UpdateInfo(
      version: map['version'] as String,
      os: List<OsInfo>.from(
        (map['os'] as List).map<OsInfo>(
          (x) => OsInfo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateInfo.fromJson(String source) =>
      UpdateInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
