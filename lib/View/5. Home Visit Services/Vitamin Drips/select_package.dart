import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/dynamin_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class SelectPackagesPage extends StatelessWidget {
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  const SelectPackagesPage({
    Key? key,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    VitaminCartController cartController = Get.put(VitaminCartController());
  // String? selectedService;
 cartController.fetchServices();
  // Method to handle the service selection
  void _onServiceSelected(String serviceName, String id, String description,
      String components,String instructions, String price, String imagePath) {

    Get.to(SelectPackage(
      image: imagePath,
      id: id,
      title: serviceName,
      description: description,
      instructions: instructions,
      price: price,
      components: components,
      address: address,
      userModel: userModel,
      firebaseUser: firebaseUser,
    ));
  }


  final List<String> imagePaths = [
    "assets/images/vitamin1.png",
    "assets/images/vitamin2.png",
    "assets/images/vitaminthree.png",
  ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Select Packages'.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StepProgressBar(currentStep: 2, totalSteps: 4)),
          // Address Section
         Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 0),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      address,

                    style: TextStyle(fontSize: 14,fontFamily: "Roboto", color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: SizedBox(
              height: 32, // Set your desired height
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Vitamin IV",
                  hintStyle: const TextStyle(
                    color: Colors.grey, // Set the hint text color
                    fontSize: 14,
                    fontFamily: "Roboto" // Optional: Set font size for hint text
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color:
                            Color(0xFFC7C7C7), // Color for the default border
                        width: 0.51, // Border width
                      )),
                  contentPadding:
                      const EdgeInsets.only(top: 1), // Adjust padding for text
                ),
              ),
            ),
          ),

          // GridView Section
          Expanded(
            child: Container(
              color: Color(0xFFEEF8FF),
              padding:
                  const EdgeInsets.only(left: 16.0,right: 16, top: 20.0,),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.4,
                ),
                itemCount: cartController.servicesList.length,
                
                itemBuilder: (context, index) {

                  final service = cartController.servicesList[index];

                      String languageCode = Get.locale?.languageCode ?? 'en';

                      final localizedData = languageCode == 'ar'
                          ? service.localized.ar
                          : service.localized.en;
                  String imagePath = imagePaths[index % imagePaths.length];
                  return GestureDetector(
                    onTap: (){
                      _onServiceSelected(
                    localizedData.serviceName, service.id, localizedData.description, localizedData.components,localizedData.instructions, localizedData.price, imagePath);
                    },
                    child: Card(
                      
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Rounded corners
                      ),
                      elevation: 2, // Subtle shadow
                      child: Container(
                        
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white, // White card background
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Space between image and text
                          children: [
                            // Image Section


                            Image.asset(
                              imagePath, // Replace with your asset path
                              height: 64, // Adjust size to match the design
                              width: 40,
                            ),
                            const SizedBox(
                                width: 12), // Space between image and text
                            // Text Section
                    
                            Expanded(
                              child: Container(
                                // color: Colors.green,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localizedData.serviceName,
                                      textAlign: TextAlign.end,
                                      // textDirection: TextDirection.rtl,
                                      softWrap:true,
                                      maxLines: 3,
                                      style: const TextStyle(
                                        height: 1.2,
                                        fontSize: 14,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF007ABB), // Blue text for title
                                      ),
                                    ),
                                    Container(
                                      
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue[
                                            50], // Subtle light blue background
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        localizedData.price,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .teal, // Highlighted teal price text
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    
                            // Price Tag
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Bar
          Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                      if (cartController.cartItems.isNotEmpty) {
                        Get.to(VitaminCartPage(
                          address: address,
                          userModel: userModel,
                          firebaseUser: firebaseUser,
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
                            borderRadius:
                                BorderRadius.circular(8), // Make it circular
                          ),
                          child: Obx(
                            () => Center(
                              child: Text(
                                '${cartController.cartItems.length}',
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
                        backgroundColor: cartController.isCartEmpty()
                            ? Color(0xFFD9D9D9)
                            : Color(0xFF007ABB),
                        minimumSize: const Size(160, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                      // Get.to(SelectPackage(
                      //     address: address,
                      //     userModel: userModel,
                      //     firebaseUser: firebaseUser,
                      // ));

                        if (!cartController.isCartEmpty()) {
                          Get.to(() => Vitamin_Time(
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                        }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(
                            color: cartController.isCartEmpty()
                                ? Color(0xFF9C9C9C)
                                : Colors.white,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
