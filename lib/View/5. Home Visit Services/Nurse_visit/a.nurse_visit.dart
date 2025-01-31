// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, unused_import, unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Button/myroundbutton.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/b.nurse_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_details.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class NurseVisit extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const NurseVisit(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<NurseVisit> createState() => _NurseVisitState();
}

class _NurseVisitState extends State<NurseVisit> {
  final Completer<GoogleMapController> _controller = Completer();

  NurseController nurseController = Get.put(NurseController());

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 14.4746,
  );
  final List<Marker> _marker = [];
  // final List<Marker> _list = [
  //   Marker(
  //       markerId: const MarkerId("1"),
  //       position: const LatLng(24.8846, 70.1754),
  //       infoWindow: InfoWindow(title: "Current Location".tr))
  // ];
  String stAddress = '';
  String Latitude = " ";
  String Longitude = " ";
  bool address = false;
  late Position position;
  final fireStore = FirebaseFirestore.instance.collection("User_appointments");

  void initState() {
    // nurseController.storeDuration();
    // nurseController.fetchServices();
    getCurrentLoc();
    super.initState();
    // Initial marker (optional)
    _marker.add(Marker(
      markerId: const MarkerId("1"),
      position: const LatLng(24.7136, 46.6753),
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
                    nurseController.stAddress.value = stAddress;
                    nurseController.latitude.value = Latitude;
                    nurseController.longitude.value = Longitude;

                    // nurseController.setUserOrderInfo(
                    //     widget.userModel, widget.firebaseUser);

                    // setState(() {
                    //   // fireStore.doc(widget.firebaseUser.email).set({
                    //   //   "email": widget.firebaseUser.email,
                    //   //   "name": widget.userModel.fullname,
                    //   //   "phone": widget.userModel.mobileNumber,
                    //   //   "gender": widget.userModel.gender,
                    //   //   "dob": widget.userModel.dob,
                    //   //   "address": stAddress,
                    //   //   "latitude": Latitude,
                    //   //   "longitude": Longitude,
                    //   //   "packages": [],
                    //   //   "type": "Vitamin Drips",
                    //   //   "selected_time": ""
                    //   // });
                    // });

                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Close the bottom sheet
                    // Get.to(() => VitaminServices(
                    //     address: stAddress,
                    //     userModel: widget.userModel,
                    //     firebaseUser: widget.firebaseUser));
                    Get.to(NurseDetails(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                      // address: stAddress,
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
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

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
