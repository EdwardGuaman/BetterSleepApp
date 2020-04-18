import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'MainAlarmPage.dart';
import 'MainSleepPage.dart';

const String isolateName = 'isolate';
final ReceivePort port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.fast_forward),
              color: Colors.lightBlue,
              iconSize: 100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SleepPage()),
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Text("Quick Alarms"),
            ),
            IconButton(
              icon: Icon(Icons.alarm),
              color: Colors.purple,
              iconSize: 100,
              onPressed: () {
                List<Alarm> _alarms = List<Alarm>();
                _read().then((value) {
                  var jsonList = jsonDecode(value) as List;
                  for (var i = 0; i < jsonList.length; i++) {
                    Alarm temp = Alarm.fromJson(jsonList[i]);
                    print(temp.alarmTime);
                    _alarms.add(temp);
                  }
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmPage(_alarms)),
                );
              },
            ),
            Text("Saved Alarms"),
          ],
        ),
      ),
    );
  }

  Future<String> _read() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/Alarms.txt');
    return file.readAsString();
  }
}
