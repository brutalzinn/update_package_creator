import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpdateInfo {
  String version;
  String url;
  UpdateInfo({
    required this.version,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'url': url,
    };
  }

  factory UpdateInfo.fromMap(Map<String, dynamic> map) {
    return UpdateInfo(
      version: map['version'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateInfo.fromJson(String source) =>
      UpdateInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
