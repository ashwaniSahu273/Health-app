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
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.8846, 67.1754),
    zoom: 14.4746,
  );
  List<Marker> _marker = [];
  // List<Marker> _list = [
  //   Marker(
  //       markerId: MarkerId("1"),
  //       position: LatLng(24.8846, 70.1754),
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
    //       markerId: MarkerId("2"),
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
                        "type": "Nurse Visit",
                        "selected_time": ""
                      });

                      Navigator.pop(context);
                      Get.back();
                      Get.to(() => Nurse_Time(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                            providerData: {
                              "email": FirebaseAuth.instance.currentUser!.email,
                              "address": stAddress,
                              "type": "Nurse Visit",
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
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

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
          onTap: _handleTap
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
