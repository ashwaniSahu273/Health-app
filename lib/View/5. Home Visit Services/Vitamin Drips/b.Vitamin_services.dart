// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';

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
  // State variable to keep track of selected service
  String? selectedService;

  // Method to handle the service selection
  void _onServiceSelected(
      String serviceName, String description, String components, String price) {
    setState(() {
      selectedService = serviceName;
    });

    Get.to(() => Vitamin_Time(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
          providerData: {
            "email": FirebaseAuth.instance.currentUser!.email,
            "address": widget.address,
            "type": serviceName,
            "benefits": description,
            "components": components,
            "price": price, // Pass the price
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 230, 251),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.to(() => HomePage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser,
                ));
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          "Packages",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
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
                        const SizedBox(width: 10),
                        const VerticalDivider(color: Colors.black),
                        const Icon(Icons.location_on, color: Colors.green),
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
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Memory Enhancement IV Therapy",
                description:
                    "It calms the stimulated mind and plays an important role in forming brain cells and enhances memory.",
                components:
                    "Vitamin B12, Zinc, Selenium, Calcium Gluconate, Magnesium Sulphate, Vitamin C, Amino Acids, Potassium Chloride, Normal Saline, Water-Soluble Vitamins, Thiamine (Vitamin B1)",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Hydration IV Therapy",
                description:
                    "Ideal for recovery from an action-packed weekend or busy lifestyle, boost energy levels while replenishing the electrolytes in your body.",
                components:
                    "Vitamin C, Potassium Chloride, Magnesium Sulphate, Zinc, Normal Saline, Thiamine (Vitamin B1), Amino Acids, Water-Soluble Vitamins.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Antiaging IV Therapy",
                description:
                    "The ladies favourite a powerful hit of antioxidants with antiaging properties supporting detox, hydration, optimal hair, nail and skin health.",
                components:
                    "MultiVitamins Mixture, Vitamin C, Zinc, Selenium, Magnesium Sulphate, Potassium Chloride, Amino Acids, Vitamin B12, Normal Saline.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Stress Relief IV Therapy",
                description:
                    "It calms the body, improves mood, reduces anxiety and other signs of stress.",
                components:
                    "Magnesium Sulphate, Zinc, Selenium, Amino Acids, Vitamin C, Vitamin B12, Normal Saline, Thiamine (Vitamin B1), Water-Soluble Vitamins.",
                price: "900 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Fitness Boost IV Therapy",
                description:
                    "Recommended for fitness enthusiasts or those who maintain an active lifestyle.",
                components:
                    "Vitamin C, Magnesium Sulphate, Calcium Gluconate, Potassium Chloride, Zinc, Vitamin B12, Glutamine, Normal Saline, Water-Soluble Vitamins, L-Carnitine, Thiamine (Vitamin B1).",
                price: "1080 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Energy Boost IV Therapy",
                description:
                    "To restore energy, build proteins, support antioxidants, and increase productivity.",
                components:
                    "Vitamin B12, Vitamin C, Magnesium Sulphate, Potassium Chloride, Zinc, Selenium, L-Carnitine, Glutamine, Normal Saline, Multivitamins Mixture.",
                price: "1170 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Post Sleeve Gastrectomy IV Therapy",
                description:
                    "To hydrate the body after gastric sleeve and provide better absorption for the nutrients and supplements.",
                components:
                    "Calcium Gluconate, Magnesium Sulphate, Vitamin B12, Potassium Chloride, Multivitamins Mixture, Vitamin C, Vitamin B1, Vitamin D3, Selenium, Amino Acids, Normal Saline, Trace Elements Mixture, Zinc.",
                price: "1035 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Hair Health IV Therapy",
                description:
                    "For healthy, strong, balanced hair, reduces hair loss and supports nails and skin.",
                components:
                    "Vitamin C, Zinc, Selenium, Water-Soluble Vitamins, Vitamin D3, Vitamin B12, Magnesium Sulphate, Folic Acid, Amino Acids, Normal Saline.",
                price: "1035 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Jet Lag IV Therapy",
                description:
                    "Hydration after a flight is essential for the body, this is recommended for frequent travelers to support with energy production and the immune system.",
                components:
                    "Vitamin B12, Zinc, Magnesium Sulphate, Vitamin C, Calcium Gluconate, Amino Acids, Normal Saline, Thiamine (Vitamin B1), Water-Soluble Vitamins.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Migraine Relief IV Therapy",
                description:
                    "This multivitamin relieves migraine headaches and their related symptoms.",
                components:
                    "Vitamin C, Vitamin D3, Folic Acid, Thiamine (Vitamin B1), Magnesium Sulphate, Vitamin B12, Normal Saline, Water-Soluble Vitamins.",
                price: "945 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Depression Relief IV Therapy",
                description:
                    "This multivitamin relieves Depression, Anxiety, and their related symptoms.",
                components:
                    "Selenium, Zinc, Calcium Gluconate, Amino Acids, Vitamin C, Vitamin B12, Vitamin D3, Folic Acid, Thiamine (Vitamin B1), Magnesium Sulphate, Normal Saline, Trace Elements Mixture, Water-Soluble Vitamins.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Weight Loss IV Therapy",
                description:
                    "This multivitamin aids in improving body metabolism and the rate of fat burning within the body.",
                components:
                    "L-Carnitine, Glutamine, Zinc, Calcium Gluconate, Vitamin C, Vitamin B12, Vitamin D3, Thiamine (Vitamin B1), Magnesium Sulphate, Normal Saline, Trace Elements Mixture, Water-Soluble Vitamins.",
                price: "1170 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Diet & Detox IV Therapy",
                description:
                    "Incorporate antioxidants into your regular wellness routine and remove any lingering free radicals in your body.",
                components:
                    "Vitamin C, Water-Soluble Vitamins, Potassium Chloride, Calcium Gluconate, Vitamin D3, Selenium, Trace Elements Mixture, Zinc, Thiamine, Amino Acids 10%, Magnesium Sulphate, Normal Saline 0.9%, D5W.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Mayers Cocktail IV Therapy",
                description:
                    "Restore balance, reduce the symptoms of chronic illnesses, and promote general wellness.",
                components:
                    "Calcium Gluconate, Magnesium Sulphate, Ascorbic Acid, Water-Soluble Vitamins, Thiamine, Vitamin B12, Normal Saline 0.9%, D5W.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
              const SizedBox(height: 10),
              _buildServiceCard(
                serviceName: "Immunity Boost IV Therapy",
                description:
                    "Strengthen your immunity and support whole-body wellness. Maintain a robust immune system despite fluctuations. This is the best method, whether it's for preventing wellness or treating a cold.",
                components:
                    "Vitamin C, Water-Soluble Vitamins, Magnesium Sulphate, Zinc, Potassium Chloride, Vitamin B12, Thiamine, Normal Saline 0.9%, D5W, Glutamine.",
                price: "990 SAR",
                imagePath: "assets/images/vitamin.png",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a service card
  Widget _buildServiceCard({
    required String serviceName,
    required String description,
    required String components,
    required String price,
    required String imagePath,
  }) {
    final isSelected = selectedService == serviceName;

    return Container(
      width: 370,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isSelected ? Colors.blue : Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              onTap: () => _onServiceSelected(
                  serviceName, description, components, price),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 169, 214, 246),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image(image: AssetImage(imagePath)),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(serviceName,
                          style: const TextStyle(color: Colors.blue))),
                  Icon(
                    Icons.circle_outlined,
                    color: Colors.blue,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description),
                  const SizedBox(height: 10),
                  Text(
                    "Price: $price",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 340,
              height: 130,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 169, 214, 246),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Components Included:",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(components),
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
