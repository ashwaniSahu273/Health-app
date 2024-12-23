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
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.text,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
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
