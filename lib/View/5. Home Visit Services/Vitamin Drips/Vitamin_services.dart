// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';

class VitaminServices extends StatefulWidget {
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  const VitaminServices({
    Key? key,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<VitaminServices> createState() => _VitaminServicesState();
}

class _VitaminServicesState extends State<VitaminServices> {
  UserModel userModel22 = UserModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 230, 251),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.to(() => HomePage(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser));
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          "Packages",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 370,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Your location".tr),
                        SizedBox(
                          width: 10,
                        ),
                        VerticalDivider(
                          color: Colors.black,
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        Expanded(
                          child: Text(
                            widget.address,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 300, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => PaymentDetailsPage(
                              selectedProviderData: {},
                              selectedTime: "",
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: {},
                              packageName: "Healthy hair",
                              packagePrice: "200SAR"));
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 169, 214, 246),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/vitamin.png"),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Healthy hair",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("To restore energy"),
                            Text("build proteins support"),
                            Text("antioxidants, and"),
                            Text("increase productivity"),
                            Text("starting from 1300 SAR"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 214, 246),
                          borderRadius: BorderRadius.circular(12),
                        ), // Adjusted height
                        // Adjust the color as needed
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Vitamin B12, Vitamin C, Magnesium",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Sulphate, Potassium Chloride",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "To restore energy,",
                                  style: TextStyle(fontSize: 16),
                                ),
                              
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 300, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => PaymentDetailsPage(
                            selectedProviderData: {},
                              selectedTime: "",
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: {},
                              packageName: "Healthy hair",
                              packagePrice: "200SAR"));
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 169, 214, 246),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/vitamin.png"),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hydration",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("To restore energy"),
                            Text("build proteins support"),
                            Text("antioxidants, and"),
                            Text("increase productivity"),
                            Text("starting from 1300 SAR"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 214, 246),
                          borderRadius: BorderRadius.circular(12),
                        ), // Adjusted height
                        // Adjust the color as needed
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Vitamin B12, Vitamin C, Magnesium",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Sulphate, Potassium Chloride",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "To restore energy,",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 300, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => PaymentDetailsPage(
                            selectedProviderData: {},
                              selectedTime: "",
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: {},
                              packageName: "Healthy hair",
                              packagePrice: "200SAR"));
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 169, 214, 246),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/vitamin.png"),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jet Lag",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("To restore energy"),
                            Text("build proteins support"),
                            Text("antioxidants, and"),
                            Text("increase productivity"),
                            Text("starting from 1300 SAR"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 214, 246),
                          borderRadius: BorderRadius.circular(12),
                        ), // Adjusted height
                        // Adjust the color as needed
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Vitamin B12, Vitamin C, Magnesium",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Sulphate, Potassium Chloride",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "To restore energy,",
                                  style: TextStyle(fontSize: 16),
                                ),
                               
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 300, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => PaymentDetailsPage(
                            selectedProviderData: {},
                              selectedTime: "",
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: {},
                              packageName: "Healthy hair",
                              packagePrice: "200SAR"));
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 169, 214, 246),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/vitamin.png"),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Post Sleeve Gastrectomy",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("To restore energy"),
                            Text("build proteins support"),
                            Text("antioxidants, and"),
                            Text("increase productivity"),
                            Text("starting from 1300 SAR"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 214, 246),
                          borderRadius: BorderRadius.circular(12),
                        ), // Adjusted height
                        // Adjust the color as needed
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Vitamin B12, Vitamin C, Magnesium",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Sulphate, Potassium Chloride",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "To restore energy,",
                                  style: TextStyle(fontSize: 16),
                                ),
                              
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 300, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => PaymentDetailsPage(
                            selectedProviderData: {},
                              selectedTime: "",
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: {},
                              packageName: "Healthy hair",
                              packagePrice: "200SAR"));
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 169, 214, 246),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/vitamin.png"),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Antiaging",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("To restore energy"),
                            Text("build proteins support"),
                            Text("antioxidants, and"),
                            Text("increase productivity"),
                            Text("starting from 1300 SAR"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 214, 246),
                          borderRadius: BorderRadius.circular(12),
                        ), // Adjusted height
                        // Adjust the color as needed
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Vitamin B12, Vitamin C, Magnesium",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Sulphate, Potassium Chloride",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "To restore energy,",
                                  style: TextStyle(fontSize: 16),
                                ),
                               
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 300, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => PaymentDetailsPage(
                            selectedProviderData: {},
                              selectedTime: "",
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: {},
                              packageName: "Healthy hair",
                              packagePrice: "200SAR"));
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 169, 214, 246),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/vitamin.png"),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Energy Boost",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("To restore energy"),
                            Text("build proteins support"),
                            Text("antioxidants, and"),
                            Text("increase productivity"),
                            Text("starting from 1300 SAR"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 169, 214, 246),
                          borderRadius: BorderRadius.circular(12),
                        ), // Adjusted height
                        // Adjust the color as needed
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Vitamin B12, Vitamin C, Magnesium",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Sulphate, Potassium Chloride",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "To restore energy,",
                                  style: TextStyle(fontSize: 16),
                               )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
