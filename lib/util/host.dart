import 'dart:io';
import 'dart:typed_data';

import 'manipulate_data.dart';

class Host {
  late Socket socket;
  late Function listener;

  String ip;
  int port;

  Host(this.ip, this.port);

  void connect(Function thenConnect, Function catchError) {
    Socket.connect(ip, port).then((Socket sock) {
      socket = sock;
      thenConnect();
      socket.listen(_dataHandler,
          onError: _errorHandler,
          onDone: _successfulHandler,
          cancelOnError: false);
    }).catchError((dynamic e) {
      catchError(e.toString());
    });
  }

  void sendMessage(String text) {
    try {
      socket.write(text);
        } catch (error) {
      print('Error to send message $error');
    }
  }

  void disconnect() {
    try {
      socket.write('Exit...');
      socket.destroy();
        } catch (error) {
      print('Error to finish connect $error');
    }
  }

  void _dataHandler(Uint8List data) async {
    try {
      var requestText = ManipulateData.convertCharCodesToString(data);
      if (listener != null) {
        listener(requestText);
      } else {
        _returnError('error not listener attr');
      }
    } catch (error) {
      _returnError('error in processing data -> ${error.toString()}');
    }
  }

  void _errorHandler(dynamic errorObject, StackTrace stackError) {
    print('Error -> ${errorObject.toString}');
  }

  void _successfulHandler() => print('Finish Connect!');

  void _returnError(String text) =>
      socket.write('[${DateTime.now().toString()}] [ERROR]: $text');
}
