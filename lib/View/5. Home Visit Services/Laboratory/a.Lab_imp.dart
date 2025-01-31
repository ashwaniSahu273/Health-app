// ignore_for_file: prefer_final_fields, prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Button/myroundbutton.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/labtest.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class LabImp extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const LabImp(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<LabImp> createState() => _LabImpState();
}

class _LabImpState extends State<LabImp> {
  Completer<GoogleMapController> _controller = Completer();
  LabController labController = Get.put(LabController());

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.8846, 67.1754),
    zoom: 14.4746,
  );
  final List<Marker> _marker = [];
  String stAddress = '';
  String Latitude = " ";
  String Longitude = " ";
  // final position = "";
  bool address = false;
  bool isLoading = false;
  late Position position;
  final fireStore = FirebaseFirestore.instance.collection("User_appointments");

  void initState() {
    // labController.storeServices();
    getCurrentLoc();
    super.initState();

    _marker.add(Marker(
      markerId: const MarkerId("1"),
      position: const LatLng(24.8846, 67.1754),
      infoWindow: InfoWindow(title: "Initial Location"),
    ));
  }

  void getCurrentLoc() async {
    position = await getUserCurrentLocation();
  }

  Future<void> _handleTap(LatLng tappedPoint) async {
    final GoogleMapController mapController = await _controller.future;

    // Animate to tapped location
    mapController.animateCamera(CameraUpdate.newLatLng(tappedPoint));

    // Address fetching and marker updates
    setState(() {
      stAddress = "Fetching address...";
      Latitude = tappedPoint.latitude.toString();
      Longitude = tappedPoint.longitude.toString();

      _marker.clear();
      _marker.add(Marker(
        markerId: const MarkerId("selectedLocation"),
        position: tappedPoint,
        infoWindow: InfoWindow(title: "Selected Location"),
      ));
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(
        tappedPoint.latitude, tappedPoint.longitude);

    setState(() {
      stAddress =
          "${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}";
    });

    // _showAddressBottomSheet();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();
  }

  void _showAddressBottomSheet() async {
    print("My Location".tr);
    print("${position.latitude} ${position.longitude}");

    // Get address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    stAddress =
        "${placemarks.reversed.last.country} ${placemarks.reversed.last.locality} ${placemarks.reversed.last.street}";

    setState(() {
      _marker.add(Marker(
          markerId: const MarkerId("2"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "My Location".tr)));
      Latitude = position.latitude.toString();
      Longitude = position.longitude.toString();
    });

    // Show bottom sheet
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address:".tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              stAddress.isNotEmpty ? stAddress : "Fetching address...",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog
                Get.defaultDialog(
                  title: "Confirm".tr,
                  middleText: "Are you sure you want to confirm".tr,
                  onCancel: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  onConfirm: () {
                    labController.stAddress.value = stAddress;
                    labController.latitude.value = Latitude;
                    labController.longitude.value = Longitude;

                    Navigator.pop(context);
                    Get.to(() => LabTest(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          address: stAddress,
                        ));
                  },
                  textCancel: "Cancel".tr,
                  textConfirm: "Confirm".tr,
                );
              },
              child: const Text("Send"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final auth = FirebaseAuth.instance;
    // final user = auth.currentUser;

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: kGooglePlex,
          markers: Set<Marker>.of(_marker),
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: MyRoundButton(
          text: "Select location",
          onTap: _showAddressBottomSheet,
        ),
      ),
    );
  }
}
