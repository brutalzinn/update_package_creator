import 'dart:convert';
import 'dart:io';
import 'package:update_package_creator/core/models/config.dart';

class ConfigManager {
  static const String configFilePath = 'config.json';
  static Future<ConfigModel> loadConfig() async {
    try {
      File file = File(configFilePath);
      String contents = await file.readAsString();
      return ConfigModel.fromJson(contents);
    } catch (e) {
      return ConfigModel(
        url: "http://robertocpaes.dev/test",
        manifestPath: "manifest.json",
        isSmartManifest: true,
        isAutoIncrement: true,
      );
    }
  }

  static Future<void> saveConfig(ConfigModel configModel) async {
    File file = File(configFilePath);
    await file.writeAsString(configModel.toJson());
  }
}
