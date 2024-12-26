// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';

class RoundButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool loading;
  final Color? color;
  final Color? borderColor;

  const RoundButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.color,
      this.borderColor,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 55,
          width: 250,
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            border: Border.all(color:borderColor?? Colors.black),
            borderRadius: BorderRadius.circular(12),
            //border color
          ),
          child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
          )),
    );
  }
}
