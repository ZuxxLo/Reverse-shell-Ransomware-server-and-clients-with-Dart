import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../util/manipulate_data.dart';
import '../../modules/modules.dart';

// modify with your true server address/port 
String ip = '127.0.0.1';
int port = 8000;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final title = 'MART';
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.deepPurple,
        // brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      title: title,
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var nbmer = 0;
  Socket? channel;
  late StreamSubscription<List<int>> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() async {
    try {
      channel = await Socket.connect(ip, port);
      channel!.write("#" +
          ManipulateData.convertMapToJsonString(
              await Modules().getInfo(context)));

      _streamSubscription =
          channel!.asBroadcastStream().listen((List<int> data) {
        _handleData(Uint8List.fromList(data));
      });
    } catch (e) {
      print("Socket connection error: $e");
    }
  }

  void _handleData(Uint8List data) {
    String requestText = ManipulateData.convertCharCodesToString(data);

    try {
      var requestMap = ManipulateData.convertJsonToMap(requestText);
      print(requestMap);
      Modules()
          .selectorFromMap(map: requestMap, context: context)
          .then((value) => channel!.write(value));
    } catch (err) {
      print(err);
    }

    nbmer += 1;
  }

  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const FilesTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('File Manager'),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel(); // Cancel the stream subscription

    channel!.close();
    super.dispose();
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 80,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 20),
          Text(
            "Welcome to the Home Page",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 20),
          Text(
            'Browse your files here',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings_outlined,
            size: 80,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 20),
          Text(
            'Adjust your settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
