import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final String conditionText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.labelText,
    required this.conditionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        keyboardType: TextInputType.text,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFD4D2D0), // Background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), // Slightly rounded corners
            borderSide: BorderSide.none, // No border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none, // No border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none, // No border
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, // Padding inside the field
            vertical: 14,
          ),
          hintText: labelText, // Hint as label text
          hintStyle:const TextStyle(
            fontSize: 16,
            color: Colors.black, // Subtle hint color
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return conditionText;
          }
          return null;
        },
      ),
    );
  }
}
