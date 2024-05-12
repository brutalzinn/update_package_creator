import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/core/constants.dart';
import 'package:update_package_creator/core/models/config.dart';
import 'package:update_package_creator/core/models/manifest.dart';

class Util {
  static String getManifestFile(ConfigModel config) {
    final manifestFile =
        p.join(config.manifestDirPath, Constants.manifestFilename);
    return manifestFile;
  }

  static String getVersionFile(ConfigModel config) {
    final versionFile =
        p.join(config.manifestDirPath, Constants.versionFilename);
    return versionFile;
  }

  static int compareVersions(String v1, String v2) {
    List<int> v1Parts = v1.split('.').map(int.parse).toList();
    List<int> v2Parts = v2.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }

  ///if lenght is not three and doesnt has dots.. The version is wrong format

  static bool isValidVersion(String version) {
    List<String> parts = version.split('.');
    final result = parts.length == 3;
    return result;
  }

  static Future<String> readAndIncrementVersion(String versionFilePath) async {
    File versionFile = File(versionFilePath);
    if (!await versionFile.exists()) {
      await versionFile.create();
      await versionFile.writeAsString('1.0.0');
      return '1.0.0';
    }
    String currentVersion = await versionFile.readAsString();
    if (isValidVersion(currentVersion) == false) {
      throw Exception(
          "Version format is incorrect. Expected format 'major.minor.patch'");
    }
    List<String> parts = currentVersion.split('.');
    int patchVersion = int.parse(parts[2]);
    patchVersion += 1; // Increment patch number
    String newVersion = "${parts[0]}.${parts[1]}.$patchVersion";
    await versionFile.writeAsString(newVersion); // Write back the new version
    return newVersion;
  }

  static Future<String> readVersion(String versionFilePath) async {
    File versionFile = File(versionFilePath);
    if (!await versionFile.exists()) {
      return '1.0.0';
    }
    String currentVersion = await versionFile.readAsString();
    List<String> parts = currentVersion.split('.');
    if (parts.length != 3) {
      throw Exception(
          "Version format is incorrect. Expected format 'major.minor.patch'");
    }
    return currentVersion;
  }

  static Future<void> createUpdatePackage(
      String sourceDir, String outputPath) async {
    Directory dir = Directory(sourceDir);
    if (!await dir.exists()) {
      throw Exception("Source directory does not exist.");
    }
    List<File> files = await dir
        .list(recursive: true)
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
    ZipFileEncoder encoder = ZipFileEncoder();
    encoder.create(outputPath);
    for (File file in files) {
      await encoder.addFile(file);
    }
    encoder.close();
  }

  static Future<Manifest> readManifestFile(String manifestFilePath) async {
    File manifestFile = File(manifestFilePath);
    if (await manifestFile.exists()) {
      String content = await manifestFile.readAsString();
      return Manifest.fromJson(content);
    } else {
      return Manifest(updates: []);
    }
  }

  static Future<void> writeManifestFile(
      String manifestFilePath, Manifest manifest) async {
    File manifestFile = File(manifestFilePath);
    String json = manifest.toJson();
    await manifestFile.writeAsString(json);
  }
}
