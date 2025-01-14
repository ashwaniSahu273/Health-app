// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({Key? key});

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
            Icon(Icons.search,
                color: Colors.grey),
                 SizedBox(
                width: 5),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search'.tr,
                  hintStyle: TextStyle(
                    color: Colors.grey
                  ),
                  contentPadding: EdgeInsets.only(bottom:10)
                ),
              ),
            ),
            SizedBox(
                width: 10),
          ],
        ),
      ),
    );
  }
}
