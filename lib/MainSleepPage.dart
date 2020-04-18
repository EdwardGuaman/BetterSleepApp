import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
    FlutterRingtonePlayer.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        looping: true,
        volume: .5,
        asAlarm: true);
    sleep(new Duration(seconds: 10));
    FlutterRingtonePlayer.stop();
    // Get the previous cached count and increment it.

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  String jsonvoffile;

//  _write(String text) async {
//    final Directory directory = await getApplicationDocumentsDirectory();
//    final File file = File('${directory.path}/Alarms.txt');
//    await file.writeAsString(text);
//  }
//
//  Future<String> _read() async {
//    final Directory directory = await getApplicationDocumentsDirectory();
//    final File file = File('${directory.path}/Alarms.txt');
//    jsonvoffile = file.readAsStringSync();
//    return file.readAsString();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick alarms'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('5 minutes'),
                  onPressed: () {
                    AndroidAlarmManager.oneShot(Duration(minutes: 5),
                        Random().nextInt(pow(2, 31)), callback);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('10 minutes'),
                  onPressed: () {
                    AndroidAlarmManager.oneShot(Duration(minutes: 10),
                        Random().nextInt(pow(2, 31)), callback);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('15 minutes'),
                  onPressed: () {
                    AndroidAlarmManager.oneShot(Duration(minutes: 15),
                        Random().nextInt(pow(2, 31)), callback);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
