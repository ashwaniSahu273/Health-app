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
    await Get.dialog(AlertDialog(
      title: const Text(
        'Enter Consultation Details',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Description Field
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            // Start Date & Time
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date & Time',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.red),
                hintText: 'Select start date and time',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
              ),
              readOnly: true,
              onTap: () => selectDateTime(startDateController),
            ),
            const SizedBox(height: 12),
            // End Date & Time
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date & Time',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Select end date and time',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
              ),
              readOnly: true,
              onTap: () => selectDateTime(endDateController),
            ),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog without saving
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        // Save Button
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
                Get.back(); // Close the dialog
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Invalid date format. Please select a valid date and time.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.black,
                );
              }
            } else {
              Get.snackbar(
                'Error',
                'All fields are required. Please fill in all details.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade100,
                colorText: Colors.black,
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    )
    );

    
  }
}
