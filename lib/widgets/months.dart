import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:room/personal/personalMonths.dart';
import 'package:room/room/roomMonths.dart';

class Months extends StatefulWidget {
  const Months({Key key}) : super(key: key);

  @override
  _MonthsState createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  DateTime selectdate;
  final format = DateFormat('MM-yyyy');

  var sel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Months'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DateTimeField(
              keyboardType: TextInputType.datetime,
              format: format,
              onShowPicker: (context, currentValue) {
                return showMonthPicker(
                  context: context,
                  firstDate: DateTime(1950),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(2099),
                );
              },
              onChanged: (dt) {
                setState(() {
                  selectdate = dt;
                  sel = DateFormat('MM-yyyy').format(selectdate);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomMonths.withMonth(
                        sel,
                      ),
                    ),
                  );
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Room',
                prefixIcon: Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DateTimeField(
              keyboardType: TextInputType.datetime,
              format: format,
              onShowPicker: (context, currentValue) {
                return showMonthPicker(
                  context: context,
                  firstDate: DateTime(1950),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(2099),
                );
              },
              onChanged: (dt) {
                setState(() {
                  selectdate = dt;
                  sel = DateFormat('MM-yyyy').format(selectdate);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalMonths.withMonth(sel)),
                  );
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Personal',
                prefixIcon: Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
