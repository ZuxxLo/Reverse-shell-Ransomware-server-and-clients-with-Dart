//import 'package:fluent_ui/fluent_ui.dart';

import '../../util/host.dart';
import '../../modules/modules.dart';
import '../../util/manipulate_data.dart';

Modules modules = Modules();
// modify with your true server address/port
Host host = Host('127.0.0.1', 8000);

void tryConnect() {
  host.connect(initialConnection, (String e) {
    print('Unable to connect, ${e.toString()}');
    Future.delayed(const Duration(seconds: 3), tryConnect);
  });
}

Future<void> initialConnection() async {
  print('connected');
  host.sendMessage(
      '#' + ManipulateData.convertMapToJsonString(await modules.getInfo(null)));
}

void dataHandler(String text) async {
  try {
    var requestMap = ManipulateData.convertJsonToMap(text);
    var responseModule = await modules.selectorFromMap(map: requestMap);
    host.sendMessage(responseModule.toString());
  } catch (error) {
    print(error.toString());
    host.sendMessage('error in processing data, ${error.toString()}');
  }
}

void main(List<String> arguments) {
  tryConnect();
  host.listener = dataHandler;
}
