// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/Button/myroundbutton.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/providers_details.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/b.doctor_time.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import '../../../Resources/AppColors/app_colors.dart';

class DoctorVisit extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const DoctorVisit(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<DoctorVisit> createState() => _DoctorVisitState();
}

class _DoctorVisitState extends State<DoctorVisit> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.8846, 67.1754),
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
  final fireStore = FirebaseFirestore.instance.collection("User_appointments");

  @override
  void initState() {
    super.initState();
    // Initial marker (optional)
    _marker.add(Marker(
      markerId: const MarkerId("1"),
      position: const LatLng(24.8846, 67.1754),
      infoWindow: InfoWindow(title: "Initial Location"),
    ));
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
    // final position = await getUserCurrentLocation();
    // print("My Location".tr);
    // print("${position.latitude} ${position.longitude}");

    // // Get address
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);
    // stAddress =
    //     "${placemarks.reversed.last.country} ${placemarks.reversed.last.locality} ${placemarks.reversed.last.street}";

    // setState(() {
    //   _marker.add(Marker(
    //       markerId: const MarkerId("2"),
    //       position: LatLng(position.latitude, position.longitude),
    //       infoWindow: InfoWindow(title: "My Location".tr)));
    //   Latitude = position.latitude.toString();
    //   Longitude = position.longitude.toString();
    // });

    // Show bottom sheet
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              stAddress.isNotEmpty ? stAddress : "Fetching address...",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog
                Get.defaultDialog(
                  title: "Confirm".tr,
                  middleText: "Are you sure you want to confirm".tr,
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onConfirm: () {
                    setState(() {
                      // Save data to Firestore
                      fireStore
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .set({
                        "email": FirebaseAuth.instance.currentUser!.email,
                        "address": stAddress,
                        "type": "Doctor Visit",
                        "selected_time": ""
                      });

                      Navigator.pop(context);
                      Get.back();
                      Get.to(() => Doctor_Time(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                            providerData: {
                              "email": FirebaseAuth.instance.currentUser!.email,
                              "address": stAddress,
                              "type": "Doctor Visit",
                            },
                          ));
                    });
                  },
                  textCancel: "Cancel".tr,
                  textConfirm: "Confirm".tr,
                );
              },
              child: Text("Send"),
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
            onTap: _handleTap),
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
