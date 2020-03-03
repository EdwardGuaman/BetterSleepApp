import 'package:flutter/material.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class Alarm {
//  alarm need to think about adding the capability for recurring alarms
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
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
