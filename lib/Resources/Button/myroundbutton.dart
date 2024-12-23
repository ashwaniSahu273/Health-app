// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';

class MyRoundButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool loading;
  const MyRoundButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 45,
          width: 220,
          decoration: BoxDecoration(
            color: MyColors.LiteblueC,
            border: Border.all(color: Colors.black),
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
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
          )),
    );
  }
}