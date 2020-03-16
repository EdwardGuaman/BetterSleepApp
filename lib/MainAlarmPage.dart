import 'package:flutter/material.dart';

import 'CreateNewAlarmPage.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class Alarm {
  /**  alarm need to think about adding the capability for recurring alarms
   *  Also need to implement the ability to save alarms list to memory
   */
  Alarm({this.isExpanded: false, this.alarmName, this.alarmTime});

  bool isExpanded;
  String alarmName;
  DateTime alarmTime;
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Alarm> _alarms = <Alarm>[
    Alarm(alarmName: "First Alarm", alarmTime: DateTime.now()),
    Alarm(alarmName: "Second Alarm", alarmTime: DateTime.now()),
    Alarm(alarmName: "Third Alarm", alarmTime: DateTime.now()),
    Alarm(alarmName: "Fourth Alarm", alarmTime: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: ListView(
            children: <Widget>[
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _alarms[index].isExpanded = !_alarms[index].isExpanded;
                  });
                },
                children: _alarms.map((Alarm alarm) {
                  return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Text(alarm.alarmName);
                      },
                      isExpanded: alarm.isExpanded,
                      body: Container(child: Text(alarm.alarmTime.toString())));
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
                  MaterialPageRoute(builder: (context) => NewAlarm()),
                );
                print(Text("button pressed test"));
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
