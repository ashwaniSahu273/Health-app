import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String selectedService = 'Your Designation'.tr;

  List<String> services = [
    'Your Designation'.tr,
    'Laboratory'.tr,
    'Nurse visit'.tr,
    'Vitamin IV Drops and Fluids'.tr,
    'Doctor Visit'.tr,
    'Virtual Consultation'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty || value == 'Your Designation'.tr) {
            return "Please Select Your Designation".tr;
          }
          return null;
        },
        value: selectedService,
        onChanged: (value) {
          setState(() {
            selectedService = value!;
          });
        },
        items: services.map((service) {
          return DropdownMenuItem<String>(
            value: service,
            child: Text(service),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          hintText: "Select a Service".tr,
        ),
      ),
    );
  }
}
