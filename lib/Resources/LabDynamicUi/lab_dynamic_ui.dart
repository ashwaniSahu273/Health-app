import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';

class LabDynamicUIPage extends StatelessWidget {
  final int? id;
  final String title;
  final String description;
  final String? components;
  final String price;
  final String? image;

  const LabDynamicUIPage(
      {super.key,
       this.id,
      required this.title,
      required this.description,
      required this.price,
      this.image,
      required this.components});

  @override
  Widget build(BuildContext context) {
   LabController controller = Get.find<LabController>();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading:true,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 35,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Select Package'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // leading: Icon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white,
      body: Stack(fit: StackFit.expand, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                // ),
                child: StepProgressBar(currentStep: 2, totalSteps: 4)),
            const SizedBox(height: 16),

            // Content box
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color:  Color.fromARGB(255, 218, 232, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                  
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and price
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/1.png',
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // About section
                      const Text(
                        'About This Package',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                     const SizedBox(height: 8),
                      Text(
                        description,
                        style:const TextStyle(fontSize: 13),
                      ),
                      // const SizedBox(height: 16),

                      // Instructions
                      // Text(
                      //   'Instructions',
                      //   style: TextStyle(
                      //       fontSize: 14, fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   '• Please note that Post Sleeve Gastrectomy IV should be taken (3) months post-surgery.',
                      //   style: TextStyle(fontSize: 13),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   '• The procedure takes about 40 to 60 minutes and the injection is done at home or workplace.',
                      //   style: TextStyle(fontSize: 13),
                      // ),
                      // const SizedBox(height: 16),

                      // Components
                      // const Text(
                      //   'Components Included',
                      //   style: TextStyle(
                      //       fontSize: 14, fontWeight: FontWeight.bold),
                      // ),
                    //  const SizedBox(height: 8),
                      Text(
                        '$components',
                        style: TextStyle(fontSize: 13),
                      ),
                     const  SizedBox(height: 16),

                      // Select button

                     Obx(
                       ()=> controller.isItemInCart(id) ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           const Text(
                              'Qty:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 10),
                            Container(
                                height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  controller.decreaseQuantity(id);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                           Obx(
                             ()=> Text(
                                '${controller.getQuantityById(id)}',
                                style: TextStyle(fontSize: 18),
                              ),
                           ),
                            const SizedBox(width: 10),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                   controller.increaseQuantity(id);
                                },
                              ),
                            ),
                          ],
                        ): Center(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.addToCart(id);
                            },
                            child: Text('Select'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding:const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                          ),
                        ),
                     ),
                    ],
                  ),
                ),
              ),
            ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Shadow color
                  blurRadius: 10, // Blur radius
                  spreadRadius: 2, // Spread radius
                  offset: Offset(0, 5), // Offset in x and y direction
                ),
              ],
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
                        if (controller.cartItems.length > 0) {
                        // Get.to(LabCartPage());
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
                              color: Colors.teal, // Background color
                              borderRadius:
                                  BorderRadius.circular(8), // Make it circular
                            ),
                            child:  Obx(
                              ()=> Center(
                                child: Text(
                                  '${controller.cartItems.length}', // Cart item count
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
                        minimumSize: const Size(160, 55), // Width and height
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Border radius
                        ),
                      ),
                      onPressed: () {
                        // Get.to(() => Laboratory(
                        //             userModel: widget.userModel,
                        //             firebaseUser: widget.firebaseUser,
                        //           ));
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
      ]),
    );
  }
}
