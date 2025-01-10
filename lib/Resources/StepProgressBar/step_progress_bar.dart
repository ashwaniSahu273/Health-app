import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Back button, Title, and Search
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.arrow_back),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //     const Text(
        //       'Select Lab',
        //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.search),
        //       onPressed: () {},
        //     ),
        //   ],
        // ),
        // Step and Progress Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Step ', // First part
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '$currentStep of $totalSteps', // Second part
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8,),
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  // borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Filled progress
              FractionallySizedBox(
                widthFactor: currentStep / totalSteps,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    // borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
