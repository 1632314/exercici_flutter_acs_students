import 'package:exercise_flutter_acs/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';

class ScreenGroupSchedule extends StatefulWidget {
  final UserGroup userGroup;

  const ScreenGroupSchedule({super.key, required this.userGroup});

  @override
  State<ScreenGroupSchedule> createState() => _ScreenGroupSchedule();
}

class _ScreenGroupSchedule extends State<ScreenGroupSchedule> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late List<bool> _weekdays;
  final DateFormat _dateFormatter = DateFormat.yMd();

  static List<int> daysOfTheWeek = [
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.userGroup.schedule.fromDate;
    _endDate = widget.userGroup.schedule.toDate;
    _startTime = widget.userGroup.schedule.fromTime;
    _endTime = widget.userGroup.schedule.toTime;
    _weekdays = daysOfTheWeek.map((day) { return widget.userGroup.schedule.weekdays.contains(day);}).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    DateTime now = await DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: isStart ? DateTime(now.year - 5) : _startDate,
      lastDate: isStart ? _endDate : DateTime(now.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  _showAlert(String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(message),],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text('Info ${widget.userGroup.name}'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start ,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("From"),
                  margin: EdgeInsets.only(bottom: 20),
                ),
                Text(_dateFormatter.format(_startDate)),
                IconButton(
                  onPressed: () => _pickDate(context, true),
                  icon: Icon(Icons.calendar_month),
                  color: Theme.of(context).primaryColorDark,
                  alignment: Alignment.centerLeft,
                )
              ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                child: Text("To"),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Text(_dateFormatter.format(_endDate)),
              IconButton(
                onPressed: () => _pickDate(context, false),
                icon: Icon(Icons.calendar_month),
                color: Theme.of(context).primaryColorDark,
              ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weekdays"),
                WeekdaySelector(
                  shortWeekdays: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
                  onChanged: (int day){
                    setState(() {
                      final index = day % 7;
                      _weekdays[index] = !_weekdays[index];
                    });
                  },
                  values: _weekdays,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("From"),
                  margin: EdgeInsets.only(bottom: 20),
                ),
                Text(_startTime.format(context)),
                IconButton(
                  onPressed: () => _pickTime(context, true),
                  icon: Icon(Icons.schedule),
                  color: Theme.of(context).primaryColorDark,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child: Text("To"),
                  margin: EdgeInsets.only(bottom: 20),
                ),
                Text(_endTime.format(context)),
                IconButton(
                  onPressed: () => _pickTime(context, false),
                  icon: Icon(Icons.schedule),
                  color: Theme.of(context).primaryColorDark,
                )
              ],
            ),
            // Add more fields for schedule, allowed actions, and users
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_startDate.isAfter(_endDate)){
                    _showAlert("Range Dates", "The From date is after the To date.\n Please select a new date range.");
                  }
                  else if(_startTime.compareTo(_endTime) > 0){
                    _showAlert("Range Time", "The From time is after or on the To time.\n Please select a new time range.");
                  }
                  else{
                    List<int> newDaysOfTheWeek = daysOfTheWeek.where((day) => _weekdays[day % 7] ).toList();
                    Schedule newSchedule = Schedule(newDaysOfTheWeek, _startDate, _endDate, _startTime, _endTime);
                    widget.userGroup.schedule = newSchedule;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved')),
                    );
                  }
                });
              },
              child: const Text('Save'),
            ),
          ],
            )
        ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}