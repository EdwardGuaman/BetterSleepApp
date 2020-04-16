import 'package:flutter/material.dart';

class NewAlarm extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  DateTime finalAlarm;
  List<bool> isSelected = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Picker Date'),
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
            ToggleButtons(
              children: <Widget>[
                Text("Monday"),
                Text("Tuesday"),
                Text("Wednesday"),
                Text("Thursday"),
                Text("Friday"),
                Text("Saturday"),
                Text("Sunday"),
              ],
              onPressed: (int index) {
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              },
              isSelected: isSelected,
            ),
            RaisedButton(
              child: Text('Picker Show Date'),
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
            RaisedButton(child: Text("Create Alarm"), onPressed: () {})
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey.shade200,
    );
  }
}
