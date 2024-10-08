import 'dart:io';

class System {
  System();

  Map<String, dynamic> getInfoFromSystem() {
    var responseMap = <String, dynamic>{
      'os': '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      'lang': '${Platform.localeName}',
      'hostName': '${Platform.localHostname}',
      'ip': '${InternetAddress.loopbackIPv4.address.toString()}',
    };
    return responseMap;
  }

  static Map<String, dynamic> _mapForResult() =>
      {'status': null, 'pId': null, 'response': null};

  Future<Map> killProcess(int pId) async {
    try {
      var returnStatusKillProcess = Process.killPid(pId);
      Map result = _mapForResult();
      result['status'] = returnStatusKillProcess;
      result['pId'] = pId;
      return result;
    } catch (error) {
      Map result = _mapForResult();
      result['status'] = false;
      result['pId'] = null;
      result['response'] = '${error.toString()}';
      return result;
    }
  }

  Future<Map> executableCommand(String command) async {
    Map result = _mapForResult();
    try {
      var processResultFromRunCommand =
          await Process.run(command, [], runInShell: true);

      dynamic returnProcess = processResultFromRunCommand.stdout;

      if (returnProcess == null) {
        result['status'] = false;
        return result;
      } else {
        result['status'] = true;
        result['response'] = returnProcess.toString();
        result['pId'] = processResultFromRunCommand.pid;
        return result;
      }
    } catch (error) {
      print(error.toString());
      result['status'] = false;
      result['response'] = '${error.toString()}';
      return result;
    }
  }

  Future<Map> executableCommandInPowerShell(String command) async {
    Map result = _mapForResult();
    try {
      if (!Platform.isWindows) {
        result['status'] = false;
        result['response'] = 'Windows Only!';
        return result;
      }

      var processResultFromRunCommand = await Process.run(
          'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
          [command ?? ''],
          runInShell: true);

      dynamic returnProcess = processResultFromRunCommand.stdout;

      if (returnProcess == null) {
        result['status'] = false;
        return result;
      } else {
        result['status'] = true;
        result['response'] = returnProcess.toString();
        result['pId'] = processResultFromRunCommand.pid;
        return result;
      }
    } catch (error) {
      print(error.toString());
      result['status'] = false;
      result['response'] = '${error.toString()}';
      return result;
    }
  }
}
