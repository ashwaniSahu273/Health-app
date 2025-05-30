import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/b.nurse_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_visit_duration_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/nurse_service_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class DynamicNurse extends StatelessWidget {
  final NurseServiceModel service;
  final UserModel userModel;
  final User firebaseUser;

  const DynamicNurse({
    Key? key,
    required this.service,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NurseController controller = Get.put(NurseController());
    String languageCode = Get.locale?.languageCode ?? 'en';

    final localizedData =
        languageCode == 'ar' ? service.localized.ar : service.localized.en;

    if (languageCode == 'ar') {
      controller.fetchNurseVisitArDuration();
    } else {
      controller.fetchNurseVisitDuration();
    }

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
              'Nurse Visit'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
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
              child: const StepProgressBar(currentStep: 2, totalSteps: 4)),
          Expanded(
            child: Container(
              color: const Color(0xFFEEF8FF),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package Card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(
                                      0xFFE6F5FF), // Circle background color
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    service.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                          "assets/images/doctorVisit.png",
                                          fit: BoxFit.cover);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localizedData.serviceName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto",
                                        color: Color(0xFF007ABB),
                                      ),
                                    ),
                                    service.type == "package"
                                        ? Text(
                                            maxLines: 2,
                                            localizedData.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,

                                              // Highlighted teal price text
                                            ),
                                          )
                                        : Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              localizedData.price,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700],
                                              ),
                                            ),
                                          ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Obx(
                                          () => controller
                                                  .isItemInCart(service.id)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Qty: '.tr,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[200],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .decreaseQuantity(
                                                                  service.id);
                                                        },
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.remove,
                                                            size:
                                                                16, // Adjust size to fit nicely inside the circle
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Obx(
                                                      () => Text(
                                                        '${controller.getQuantityById(service.id)}',
                                                        style: const TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[200],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .increaseQuantity(
                                                                  service.id);
                                                        },
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.add,
                                                            size:
                                                                16, // Adjust size to fit nicely inside the circle
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .addToCart(service.id);
                                                    if (service.type ==
                                                        "package") {
                                                      controller.updatePrice(
                                                          service.id);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF007ABB), // Subtle light blue background
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      "Select".tr,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .white, // Highlighted teal price text
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      service.type == "package"
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 8,
                                    ),
                                    child: Text(
                                      "About This Package".tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      localizedData.about,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      const SizedBox(height: 16),

                      // Components Included

                      // const SizedBox(height: 8),
                      service.type == "package"
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.white,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Service Includes".tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: [
                                          ...localizedData.serviceIncludes
                                              .split(
                                                  ',') // Split string into a list
                                              .map((service) =>
                                                  _buildBulletPoint(service
                                                      .trim())) // Trim whitespace and map to _buildChip
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 16),

                      service.type == "package"
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.white,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Terms of Service".tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: [
                                          ...localizedData.termsOfService
                                              .split(
                                                  '.') // Split string into a list
                                              .map((service) => service.trim())
                                              .where((service) =>
                                                  service.isNotEmpty)
                                              .map((service) =>
                                                  _buildBulletPoint(service
                                                      .trim())) // Trim whitespace and map to _buildChip
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),

                      service.type == "package"
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Select duration of service".tr,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 250,
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 2.5,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                        itemCount:
                                            controller.durationList.length,
                                        itemBuilder: (context, index) {
                                          final durationService =
                                              controller.durationList[index];

                                          return Obx(
                                            () => GestureDetector(
                                              onTap: () {
                                                controller.selectedIndex.value =
                                                    index;
                                                NurseVisitDuration nurseVisit =
                                                    NurseVisitDuration(
                                                  duration:
                                                      durationService.duration,
                                                  hours: durationService.hours,
                                                  price: durationService.price,
                                                );

                                                controller.durationData.value =
                                                    nurseVisit.toJson();

                                                controller
                                                    .updatePrice(service.id);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: controller
                                                              .selectedIndex
                                                              .value ==
                                                          index
                                                      ? Colors.blue[50]
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: controller
                                                                .selectedIndex
                                                                .value ==
                                                            index
                                                        ? Colors.blue
                                                        : Colors.grey[300]!,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[100]!,
                                                      blurRadius: 1,
                                                      offset: const Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      durationService.duration,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.blue[700],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      durationService.hours,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Starting".tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .blue[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Text(
                                                            durationService
                                                                .price,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .blue[700],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                      minimumSize: const Size(160, 55),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8), // Padding
                    ),
                    onPressed: () {
                      if (controller.cartItems.isNotEmpty) {
                        Get.to(NurseCartPage(
                          // service: service,
                          address: controller.stAddress.value,
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
                            color: const Color(0xFF009788), // Background color
                            borderRadius:
                                BorderRadius.circular(8), // Make it circular
                          ),
                          child: Obx(
                            () => Center(
                              child: Text(
                                '${controller.cartItems.length}',
                                style: const TextStyle(
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "schyler",
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
                            ? const Color(0xFFD9D9D9)
                            : const Color(0xFF007ABB),
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

                        if (!controller.isCartEmpty()) {
                          Get.to(() => Nurse_Time(
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                        }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(
                            fontFamily: "schyler",
                            color: controller.isCartEmpty()
                                ? const Color(0xFF9C9C9C)
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15)),
              child: const Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

}
