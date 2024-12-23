import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';

class Provider_Completed_Requests extends StatelessWidget {
  const Provider_Completed_Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          "Completed Requests:".tr,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 1),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 2),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 3),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 4),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 5),
      ],
    );
  }

  Widget buildRequestTile(String title, String description, int elevation) {
    return Card(
      elevation: elevation.toDouble(),
      child: ListTile(
        tileColor: MyColors.liteGreen,
        title: Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            )),
        subtitle: Text(description, style: const TextStyle(color: Colors.white)),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
