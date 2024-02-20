import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class DatePickerPage extends StatefulWidget {
  DateTime? scheduleTime;
  DatePickerPage({
    Key? key,
    required this.scheduleTime,
  }) : super(key: key);

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => widget.scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
