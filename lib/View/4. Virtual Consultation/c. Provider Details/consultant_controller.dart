import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ConsultationController extends GetxController {
  // Controllers for the dialog input fields
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  var isSubmitting = false.obs;

  // Date format
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  // Data to store consultation details
  RxMap<String, dynamic> consultationData = <String, dynamic>{}.obs;

  // Select date and time
  Future<void> selectDateTime(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!, // Get context from GetX
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: Get.context!,
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
        controller.text = dateFormat.format(combinedDateTime);
      }
    }
  }

  // Open dialog
  Future<void> openConsultationDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('Enter Consultation Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date & Time',
                  labelStyle: TextStyle(color: Colors.grey),
                  hintStyle: TextStyle(color: Colors.red),
                  hintText: 'Select start date and time',
                ),
                readOnly: true,
                onTap: () => selectDateTime(startDateController),
              ),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date & Time',
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: 'Select end date and time',
                ),
                readOnly: true,
                onTap: () => selectDateTime(endDateController),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog without saving
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (descriptionController.text.isNotEmpty &&
                  startDateController.text.isNotEmpty &&
                  endDateController.text.isNotEmpty) {
                try {
                  // Save data to RxMap
                  consultationData.value = {
                    'description': descriptionController.text,
                    'startDateTime': dateFormat
                        .parse(startDateController.text)
                        .toIso8601String(),
                    'endDateTime': dateFormat
                        .parse(endDateController.text)
                        .toIso8601String(),
                  };
                  Get.back(); // Close dialog
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Invalid date format. Please select a valid date and time.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );

    // Debugging
    print("++++++ Consultation Data: $consultationData");
  }
}
