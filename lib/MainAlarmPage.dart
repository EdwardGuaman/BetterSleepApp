import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';

import 'CreateNewAlarmPage.dart';

class AlarmPage extends StatelessWidget {
  final List<Alarm> _alarms;

  AlarmPage(this._alarms);

  //  code to read from file needs to be moved
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(alarms: _alarms),
    );
  }
}

class Alarm {
  Alarm(this.isExpanded, this.alarmName, this.alarmTime, this.id);

  bool isExpanded;
  String alarmName;
  DateTime alarmTime;
  int id;

  Map toJson() =>
      {
        'isExpanded': isExpanded,
        'alarmName': alarmName,
        'alarmTime': alarmTime.toString(),
        'id': id,
      };

  factory Alarm.fromJson(dynamic json) {
    return Alarm(json['isExpanded'] == 'true', json['alarmName'] as String,
        DateTime.parse(json['alarmTime']), json['id'] as int);
  }
}

class MyStatefulWidget extends StatefulWidget {
  final List<Alarm> alarms;

  MyStatefulWidget({Key key, @required this.alarms}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
//    TODO add ability to delete alarm
    return Column(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: ListView(
            children: <Widget>[
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    widget.alarms[index].isExpanded =
                    !widget.alarms[index].isExpanded;
                  });
                },
                children: widget.alarms.map((Alarm alarm) {
                  return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Text(alarm.alarmName);
                      },
                      isExpanded: alarm.isExpanded,
                      body: ListTile(
                        title: Text(alarm.alarmTime.toString()),
                        onLongPress: () {
                          setState(() {
                            widget.alarms.removeWhere(
                                    (currentItem) => alarm == currentItem);
                            AndroidAlarmManager.cancel(alarm.id);
                          });
                        },
                      ));
                }).toList(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 5),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewAlarm(widget.alarms)),
                );
              },
              child: Icon(Icons.add_circle_outline),
              backgroundColor: Colors.green,
            ),
          ),
        )
      ],
    );
  }
}
