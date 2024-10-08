import 'dart:convert';
import 'dart:io';

class Client {
  late Socket socket;
  late String ip;
  late int port;
  late String os;
  late String lang;

  late Function handler;

  Client(Socket sock) {
    _init(sock);
  }

  void _init(Socket sockClient) {
    socket = sockClient;
    ip = socket.remoteAddress.address;
    port = socket.remotePort;
  }

  void listener(Function hd) {
    handler = hd;
    socket.listen(_dataHandler);
  }

  void _dataHandler(List data) {
    try {
      var text = String.fromCharCodes(Iterable.castFrom(data)).trim();
      if (text.startsWith('#')) {
        var getMapString = text.replaceAll('#', '');
        Map mapInfoClient = json.decode(getMapString);
        if (mapInfoClient.containsKey('os')) {
          os = mapInfoClient['os'];
          lang = mapInfoClient['lang'];
        }
      } else {
        handler(text);
      }
    } catch (error) {
      print('\x1B[31mError: $error\x1B[31m');
    }
  }

  void sendMessage(String text) {
    try {
      socket.write(text);
        } catch (error) {
      print('\x1B[31mError to send message: $error\x1B[31m');
    }
  }

  void destroy() {
    print('Destroy Client \x1B[31m$ip\x1B[31m');
    socket.destroy();
  }
}
