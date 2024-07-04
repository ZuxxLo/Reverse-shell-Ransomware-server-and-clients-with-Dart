import 'package:fluent_ui/fluent_ui.dart';

import '../util/host.dart';
import '../../modules/modules.dart';
import '../../util/manipulate_data.dart';

Modules modules = Modules();
// modify with your true server address/port
Host host = Host('127.0.0.1', 8000);

const purpleColor = Color.fromRGBO(149, 0, 255, 1);
const whiteColor = Color.fromRGBO(255, 255, 255, 1);
var selectedTileColor = ButtonState.all(purpleColor.withOpacity(0.1));

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    HomePage(),
    FilesPage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
          backgroundColor: purpleColor,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "File Manager",
              style: TextStyle(color: whiteColor, fontSize: 20),
            ),
          )),
      pane: NavigationPane(
          indicator: const StickyNavigationIndicator(color: purpleColor),
          selected: _currentPage,
          onChanged: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          size: const NavigationPaneSize(openMaxWidth: 320, openMinWidth: 250),
          items: <NavigationPaneItem>[
            PaneItem(
              selectedTileColor: selectedTileColor,
              title: const Text("Home"),
              icon: const Icon(FluentIcons.home),
              body: _pages[0],
            ),
            PaneItem(
              selectedTileColor: selectedTileColor,
              title: const Text("Files"),
              icon: const Icon(FluentIcons.fabric_folder),
              body: _pages[1],
            ),
            PaneItem(
              selectedTileColor: selectedTileColor,
              title: const Text("Settings"),
              icon: const Icon(FluentIcons.settings),
              body: _pages[2],
            ),
          ]),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(FluentIcons.home, size: 100, color: purpleColor),
          SizedBox(height: 20),
          Text(
            "Welcome to the Home Page",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class FilesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(FluentIcons.fabric_folder, size: 100, color: purpleColor),
          SizedBox(height: 20),
          Text(
            "Browse your files here",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(FluentIcons.settings, size: 100, color: purpleColor),
          SizedBox(height: 20),
          Text(
            "Adjust your settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
