// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Lab%20More%20Packages/lab_more_packages.dart';
import 'package:harees_new_project/Resources/Lab%20Functions/lab_functions.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class LabTest extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String address;
  const LabTest({
    Key? key,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<LabTest> createState() => _LabTestState();
}

class _LabTestState extends State<LabTest> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.keyboard_double_arrow_left,
              size: 35,
              weight: 200,
            ),
          ),
          actions: [
            Row(
              children: [
                Text(
                  "Search".tr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_search_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ],
          // title: Text(
          //   "Laboratory",
          //   style: TextStyle(color: Colors.black),
          // ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: StepProgressBar(currentStep: 1, totalSteps: 4)),
                SizedBox(
                  height: height * 0.03,
                ), // Location starts here
                Container(
                  width: width * 0.95,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            "Your location",
                            style: TextStyle(color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5),
                            child: VerticalDivider(
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                          Expanded(
                            child: Text(widget.address),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), // Location ends here
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lab Tests",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("and Packages",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))), // texts end here
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.2,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Body function or health concern",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            children: [
                              LabFunctions(
                                imagePath: "assets/images/1.png",
                                text: "Full body",
                              ),
                              SizedBox(width: 8), // Add spacing between items
                              LabFunctions(
                                imagePath: "assets/images/1.png",
                                text: "Full body",
                              ),
                              SizedBox(width: 8),
                              LabFunctions(
                                imagePath: "assets/images/1.png",
                                text: "Full body",
                              ),
                              SizedBox(width: 8),
                              LabFunctions(
                                imagePath: "assets/images/1.png",
                                text: "Full body",
                              ),
                              SizedBox(width: 8),
                              LabFunctions(
                                imagePath: "assets/images/1.png",
                                text: "Full body",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 25,
                  width: double.infinity,
                  decoration: BoxDecoration(color: MyColors.greenColorauth),
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Most helpful packages",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Get.to(() => LabMorePackages(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                ));
                          });
                        },
                        child: Text(
                          "View all Packages",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Get.to(() => LabMorePackages(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                  ));
                            });
                          },
                          child: Icon(Icons.arrow_forward_sharp))
                    ],
                  ),
                ), //viewpackages text ends here
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.only(bottom: 80),
                    decoration: BoxDecoration(color: Colors.white),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            crossAxisCount: 2,
                            childAspectRatio: 1.3),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => PaymentDetailsPage(
                                    selectedProviderData: {},
                                    selectedTime: "",
                                    providerData: {},
                                    packageName: "Health check package",
                                    packagePrice: "200",
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              child: Container(
                                height: 50,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: MyColors.greenColorauth,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Health Check",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Packages",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Image.asset("assets/images/1.png"),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 12),
                                          child: Container(
                                            height: 22,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                "Starting 200 SAR",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.grey), // Border color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            minimumSize: Size(160, 55),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8), // Padding
                          ),
                          onPressed: () {
                            // Handle button action
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Circular container
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.teal, // Background color
                                  borderRadius: BorderRadius.circular(
                                      8), // Make it circular
                                ),
                                child: const Center(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // Space between the icon and text
                              const Text(
                                'Selected item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                MyColors.greenColorauth, // Background color
                            minimumSize:
                                const Size(160, 55), // Width and height
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Border radius
                            ),
                          ),
                          onPressed: () {
                              Get.to(() => Laboratory(
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                        ));
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
