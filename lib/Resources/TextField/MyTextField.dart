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
        child: SizedBox(
          height: 50, // Set the height you want
          child: TextFormField(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              // fontFamily: "Schyler",
            ),
            keyboardType: TextInputType.text,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              hintText: labelText, // Hint as label text
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.grey, // Matches the placeholder text color
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, // Horizontal padding
              ),
              filled: true,
              fillColor: Colors.white, // Background color of the text field
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
                borderSide: BorderSide(
                  color: Colors.grey, // Light blue border color
                  width: 0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey, // Highlighted border color
                  width: 1,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return conditionText;
              }
              return null;
            },
          ),
        ));
  }
}
