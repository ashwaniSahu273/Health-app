import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TelemedicineForm extends StatefulWidget {
  @override
  _TelemedicineFormState createState() => _TelemedicineFormState();
}

class _TelemedicineFormState extends State<TelemedicineForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  void _selectDateTime(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startDateTime = combinedDateTime;
          } else {
            _endDateTime = combinedDateTime;
          }
        });
      }
    }
  }

  Future<Map<String, dynamic>> createTelemedicineSession({
    required String summary,
    required String description,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String timeZone,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'createTelemedicineSession',
    );

    final response = await callable.call({
      'summary': summary,
      'description': description,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'timeZone': timeZone,
    });

    return response.data as Map<String, dynamic>;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _startDateTime != null &&
        _endDateTime != null) {
      try {
        final response = await createTelemedicineSession(
          summary: _summaryController.text,
          description: _descriptionController.text,
          startDateTime: DateTime.parse(_startDateTime!.toIso8601String()),
          endDateTime: DateTime.parse(_endDateTime!.toIso8601String()),
          timeZone: 'UTC', // Customize based on user location
        );

        // Show the Meet link or navigate to another screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Session Created'),
            content: Text('Meet Link: ${response['meetLink']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Telemedicine Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _summaryController,
                decoration: InputDecoration(labelText: 'Summary'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a summary' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                    'Start Date & Time: ${_startDateTime ?? 'Not Selected'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title:
                    Text('End Date & Time: ${_endDateTime ?? 'Not Selected'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, false),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
