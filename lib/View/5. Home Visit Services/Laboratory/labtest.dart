// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Lab%20More%20Packages/lab_more_packages.dart';
import 'package:harees_new_project/Resources/Lab%20Functions/lab_functions.dart';
// import 'package:harees_new_project/Resources/LabDynamicUi/lab_dynamic_ui.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
// import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/c.selected_package.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/dynamic.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/dynamin_page.dart';
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
  LabController controller = Get.put(LabController());
  void _onServiceSelected(String serviceName, id, String description,
      String components, String price) {
    Get.to(LabSelectPackage(
      id: id,
      title: serviceName,
      description: description,
      price: price,
      components: components,
      address: widget.address,
      userModel: widget.userModel,
      firebaseUser: widget.firebaseUser,
    ));
  }

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
              size: 25,
              weight: 200,
            ),
          ),
          // actions: [
          //   Row(
          //     children: [
          //       Text(
          //         "Search".tr,
          //         style: TextStyle(
          //           fontSize: 16,
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.person_search_outlined),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // ],
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
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/back_image.png"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              color: Colors.blue[50],
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
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            "Your location".tr,

                            style: TextStyle(fontSize: 16,color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 0),
                            child: VerticalDivider(
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                          Expanded(
                            child: Text(widget.address,style: TextStyle(fontSize: 14,color: Colors.black)),
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
                        "Lab Tests".tr,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("and Packages".tr,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.black))), // texts end here
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                // Container(
                //   height: height * 0.2,
                //   width: 340,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(25),
                //         topRight: Radius.circular(25)),
                //   ),
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 18, vertical: 10),
                //         child: Align(
                //             alignment: Alignment.centerLeft,
                //             child: Text(
                //               "Body function or health concern".tr,
                //               style: TextStyle(
                //                   fontSize: 16,
                //                   fontFamily: "Roboto",
                //                   fontWeight: FontWeight.w700),
                //             )),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: SingleChildScrollView(
                //           scrollDirection:
                //               Axis.horizontal, // Enable horizontal scrolling
                //           child: Row(
                //             children: [
                //               LabFunctions(
                //                 imagePath: "assets/images/1.png",
                //                 text: "Full body".tr,
                //               ),
                //               SizedBox(width: 8), // Add spacing between items
                //               LabFunctions(
                //                 imagePath: "assets/images/1.png",
                //                 text: "Diabetes".tr,
                //               ),
                //               SizedBox(width: 8),
                //               LabFunctions(
                //                 imagePath: "assets/images/1.png",
                //                 text: "Cholesterol".tr,
                //               ),
                //               SizedBox(width: 8),
                //               LabFunctions(
                //                 imagePath: "assets/images/1.png",
                //                 text: "Full body".tr,
                //               ),
                //               SizedBox(width: 8),
                //               LabFunctions(
                //                 imagePath: "assets/images/1.png",
                //                 text: "Full body".tr,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   height: 25,
                //   width: double.infinity,
                //   decoration: BoxDecoration(color: MyColors.greenColorauth),
                // ),
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
                        "Most helpful packages".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                      SizedBox(
                        width: 20,
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
                          "View all Packages".tr,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontFamily: "Roboto"),
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
                    decoration: BoxDecoration(color: Color(0xFFEEF8FF)),
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 0,
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.3),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                var item = controller.servicesList[index];
                                String languageCode =
                                    Get.locale?.languageCode ?? 'en';
                          
                                final localizedData = languageCode == 'ar'
                                    ? item.localized.ar
                                    : item.localized.en;
                          
                                return GestureDetector(
                                  onTap: () {
                                    _onServiceSelected(
                                        localizedData.serviceName,
                                        item.id,
                                        localizedData.description,
                                        localizedData.instructions,
                                        localizedData.price);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10),
                                    child: Container(
                                      height: 50,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  localizedData.serviceName,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: "Roboto",
                                                      fontSize: 16,
                                                     color:  Color(0xFF007ABB)),
                                                )),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 10, vertical: 2),
                                          //   child: Align(
                                          //       alignment: Alignment.topLeft,
                                          //       child: Text(
                                          //         "Packages",
                                          //         style: TextStyle(
                                          //             fontWeight: FontWeight.bold),
                                          //       )),
                                          // ),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
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
                                                      color: Colors.lightBlue[
                                                50]),
                                                  child: Center(
                                                    child: Text(
                                                      "${'Starting'.tr} ${localizedData.price}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,color: Colors
                                                  .teal),
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
                     SizedBox(height: 10,)
                     
                      ],
                    ),
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
                                color: Color(0xFF009788)), // Border color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            minimumSize: Size(160, 55),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8), // Padding
                          ),
                          onPressed: () {
                            if (controller.cartItems.isNotEmpty) {
                              Get.to(LabCartPage(
                                address: widget.address,
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                                //
                              ));
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Circular container
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xFF009788), // Background color
                                  borderRadius: BorderRadius.circular(
                                      8), // Make it circular
                                ),
                                child: Obx(
                                  () => Center(
                                    child: Text(
                                      '${controller.cartItems.length}',
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // Space between the icon and text
                              Text(
                                'Selected item'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF009788),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isCartEmpty()
                                  ? Color(0xFFD9D9D9)
                                  : Color(0xFF007ABB),
                              minimumSize: const Size(160, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (!controller.isCartEmpty()) {
                                Get.to(() => Selected_Package(
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser,
                                    ));
                              }
                            },
                            child: Text(
                              'Continue'.tr,
                              style: TextStyle(
                                  color: controller.isCartEmpty()
                                      ? Color(0xFF9C9C9C)
                                      : Colors.white,
                                  fontSize: 15),
                            ),
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
