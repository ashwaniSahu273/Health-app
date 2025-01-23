import 'package:flutter/material.dart';

class ConsultationInputDialog extends StatefulWidget {
  @override
  _ConsultationInputDialogState createState() =>
      _ConsultationInputDialogState();
}

class _ConsultationInputDialogState extends State<ConsultationInputDialog> {
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  void _selectDateTime(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime combinedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        controller.text = combinedDateTime.toString();
      }
    }
  }

  void _saveData() {
    final data = {
      'description': _descriptionController.text,
      'startDateTime': DateTime.parse(_startDateController.text)
          .toIso8601String(),
      'endDateTime': DateTime.parse(_endDateController.text).toIso8601String(),
    };



    Navigator.of(context).pop(data); // Close dialog and pass data back
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Consultation Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date & Time',
                hintText: 'Select start date and time',
              ),
              readOnly: true,
              onTap: () => _selectDateTime(_startDateController),
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                labelText: 'End Date & Time',
                hintText: 'Select end date and time',
              ),
              readOnly: true,
              onTap: () => _selectDateTime(_endDateController),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without saving
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveData,
          child: Text('Save'),
        ),
      ],
    );
  }
}