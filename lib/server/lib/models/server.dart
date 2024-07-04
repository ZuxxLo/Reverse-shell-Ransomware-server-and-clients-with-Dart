import 'dart:io';

class Server {
  late ServerSocket serverSocket;
  String ip;
  int port;

  Server(this.ip, this.port);

  void listen(Function cbDataHandler, Function catchError) {
    ServerSocket.bind(ip, port).then((ServerSocket server) {
      serverSocket = server;
      serverSocket.listen(
        cbDataHandler as void Function(Socket event)?,
        onError: _errorHandler,
        onDone: _successfulHandler,
        cancelOnError: true,
      );
    }).catchError(catchError);
  }

  void _errorHandler(dynamic errorObject, StackTrace stackError) =>
      print('Error -> ${errorObject.toString}');

  void _successfulHandler() => print('Finish Connect!');
}
