import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:update_package_creator/core/models/manifest.dart';

class Util {
  static Future<String> readAndIncrementVersion(String versionFilePath) async {
    File versionFile = File(versionFilePath);
    if (!await versionFile.exists()) {
      await versionFile.create();
      await versionFile.writeAsString('1.0.0');
      return '1.0.0';
    }
    String currentVersion = await versionFile.readAsString();
    List<String> parts = currentVersion.split('.');
    if (parts.length != 3) {
      throw Exception(
          "Version format is incorrect. Expected format 'major.minor.patch'");
    }
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

  /// Zips the directory at [sourceDir] and saves the zip to [outputPath]
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

    // Create the zip
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

  /// Writes the manifest to a JSON file
  static Future<void> writeManifestFile(
      String manifestFilePath, Manifest manifest) async {
    File manifestFile = File(manifestFilePath);
    String json = manifest.toJson();
    await manifestFile.writeAsString(json);
  }
}
