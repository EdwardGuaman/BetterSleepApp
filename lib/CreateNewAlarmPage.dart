import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:path_provider/path_provider.dart';

import 'MainAlarmPage.dart';
import 'main.dart';

class NewAlarm extends StatelessWidget {
  final List<Alarm> _alarms;

  NewAlarm(this._alarms);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(alarms: _alarms),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final List<Alarm> alarms;

  MyStatefulWidget({Key key, this.alarms}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
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

  DateTime finalAlarm;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/Alarms.txt');
    await file.writeAsString(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Alarm'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Choose Date'),
              onPressed: () {
                Future<DateTime> selectedDate = showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2030),
                );
                selectedDate.then((value) {
                  {
                    finalAlarm = value;
                    print(value);
                  }
                });
              },
            ),
            RaisedButton(
              child: Text('Choose Time'),
              onPressed: () {
//                TODO save to file on completion of everything(?)
                Future<TimeOfDay> selectedTime = showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                selectedTime.then((value) {
                  {
                    if (finalAlarm != null) {
                      finalAlarm = new DateTime(
                          finalAlarm.year,
                          finalAlarm.month,
                          finalAlarm.day,
                          value.hour,
                          value.minute);
                      print(finalAlarm);
                    } else {
                      var temp = DateTime.now();
                      finalAlarm = new DateTime(temp.year, temp.month, temp.day,
                          value.hour, value.minute);
                      print(finalAlarm);
                    }
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter Alarm Name",
                ),
                controller: myController,
              ),
            ),
            RaisedButton(
                child: Text("Create Alarm"),
                onPressed: () async {
                  List<Alarm> tempAlarmList = widget.alarms;
                  Alarm tempAlarm = new Alarm(false, myController.text,
                      finalAlarm, Random().nextInt(pow(2, 31)));
                  tempAlarmList.add(tempAlarm);
                  AndroidAlarmManager.oneShotAt(
                      tempAlarm.alarmTime, tempAlarm.id, callback);
                  await _write(jsonEncode(tempAlarmList));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                })
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey.shade200,
    );
  }
}
