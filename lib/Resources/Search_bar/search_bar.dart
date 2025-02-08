// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;

  const MySearchBar({Key? key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search'.tr,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(bottom: 10),
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
