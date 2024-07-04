import '../modules/crypto.dart';
import '../modules/system.dart';
import '../util/manipulate_data.dart';

class Modules {
  late System _system;

  Modules() {
    _system = System();
  }

  Future<Map> selectorFromMap(Map map) async {
    if (map.containsKey('id') &&
        map['id'].toString().isNotEmpty &&
        ManipulateData.isInt(map['id'])) {
      var id = int.parse(map['id']);
      switch (id) {
        case 1:
          return getInfo();
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
          String path = map['path'];
          String key = map['key'];
          var retn = await encryptPath(path, key);
          return retn;
        case 6:
          String path = map['path'];
          String key = map['key'];
          var retn = await decryptPath(path, key);
          return retn;
        default:
          Map<int, int>();
      }
    } else {
      return Map<int, int>();
    }

    throw new Exception();
  }

  Map getInfo() {
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

  Future<Map> encryptPath(String path, String key) {
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