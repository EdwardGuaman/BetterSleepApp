import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'MainAlarmPage.dart';
import 'main.dart';

class SleepPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: _SleepHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class _SleepHomePage extends StatefulWidget {
  _SleepHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SleepHomePageState createState() => _SleepHomePageState();
}

class _SleepHomePageState extends State<_SleepHomePage> {
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();

    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => print("Alarm?"));
  }

  static SendPort uiSendPort;

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');

    // Get the previous cached count and increment it.

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  String jsonvoffile;

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/Alarms.txt');
    await file.writeAsString(text);
  }

  Future<String> _read() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/Alarms.txt');
    jsonvoffile = file.readAsStringSync();
    return file.readAsString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            var test = Alarm(
                false, "Test", DateTime.now().add(new Duration(minutes: 1)));
            print(test);
            String asString = jsonEncode(test);
            print("before write: " + asString);
            _write(asString);
            // Navigate to second route when tapped.
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var then = _read().then((value) {
            Alarm alarm = Alarm.fromJson(jsonDecode(value));
            AndroidAlarmManager.oneShotAt(
              alarm.alarmTime,
              Random().nextInt(pow(2, 31)),
              callback,
              exact: true,
              wakeup: true,
            );
            print(alarm);
          });
        },
      ),
    );
  }
}
