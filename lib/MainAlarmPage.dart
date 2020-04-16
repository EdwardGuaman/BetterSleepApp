import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'CreateNewAlarmPage.dart';

class AlarmPage extends StatelessWidget {
//  code to read from file needs to be moved
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

//class AlarmStorage {
//  Future<String> get _localPath async {
//    final directory = await getApplicationDocumentsDirectory();
//
//    return directory.path;
//  }
//
//  Future<File> get _localFile async {
//    final path = await _localPath;
//    return File('$path/Alarms.txt');
//  }
//
//  Future<String> readFile() async {
//    try {
//      final file = await _localFile;
//
//      // Read the file.
//      return await file.readAsString();
//    } catch (e) {
//      // If encountering an error, return 0.
//      return "Error";
//    }
//  }
//  Future<File> writeFile(String asj) async {
//    final file = await _localFile;
//
//    // Write the file
//    return file.writeAsString('$asj');
//  }
//}

/**  alarm need to think about adding the capability for recurring alarms(List of booleans)
 *  Also need to complete the implementation of the ability to save alarms list to memory(Save as JSON)
 *
 *  readd {} around construct later(?)
 */
class Alarm {
  Alarm(this.isExpanded, this.alarmName, this.alarmTime);

  bool isExpanded;
  String alarmName;
  DateTime alarmTime;

  Map toJson() =>
      {
        'isExpanded': isExpanded,
        'alarmName': alarmName,
        'alarmTime': alarmTime.toString(),
      };

//  Alarm.fromJson(dynamic json)
//  : isExpanded = json['isExpanded'],
//  alarmName = json['alarmName'],
//  alarmTime = DateTime.parse(json['alarmTime']);

  factory Alarm.fromJson(dynamic json) {
    return Alarm(json['isExpanded'] == 'true', json['alarmName'] as String,
        DateTime.parse(json['alarmTime']));
  }
}


class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  _read() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/Alarms.txt');
    print(file.readAsStringSync());
    var x = jsonDecode(file.readAsStringSync())['Alarm'] as List;
    List<Alarm> s = x.map((e) => Alarm.fromJson(e)).toList();
    return s;
  }

//  TODO load alarm list from file
//    using "then" make case for when there are no alarms
//  static String _alarmListInJson = _read();
//  static var alarmObjsJson = jsonDecode(_alarmListInJson)['Alarm'] as List;
//  static List<Alarm> _alarms =
//      alarmObjsJson.map((alarmJson) => Alarm.fromJson(json)).toList();
  List<Alarm> _alarms;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_read().toString());
  }

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
