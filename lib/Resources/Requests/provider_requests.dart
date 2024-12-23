import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';

class Provider_Requests extends StatelessWidget {
  const Provider_Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Text(
          "Pending Requests:",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 1),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 2),
        buildRequestTile("Name", "Address: ABC Road , XYZ City", 3),
      ],
    );
  }

  Widget buildRequestTile(String title, String description, int elevation) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Adjust the value as needed
      ),
      elevation: elevation.toDouble(),
      child: ListTile(
        tileColor: MyColors.yellow,
        title: Text(title, style: const TextStyle(color: Colors.black)),
        subtitle: Text(description, style: const TextStyle(color: Colors.black)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
