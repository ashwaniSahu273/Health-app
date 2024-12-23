// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search...'.tr,
                ),
              ),
            ),
            SizedBox(
                width: 10),
            Icon(Icons.search,
                color: Colors.black),
          ],
        ),
      ),
    );
  }
}
