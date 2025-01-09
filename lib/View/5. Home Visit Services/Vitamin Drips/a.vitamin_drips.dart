// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_import, unused_local_variable, prefer_const_constructors, avoid_print, non_constant_identifier_names, file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/Resources/Button/myroundbutton.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/b.Vitamin_services.dart';

class Vitamin extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Vitamin({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<Vitamin> createState() => _VitaminState();
}

class _VitaminState extends State<Vitamin> {
  final Completer<GoogleMapController> _controller = Completer();

  VitaminCartController vitaminCartController =
      Get.put(VitaminCartController());

    

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

  void initState() {

    vitaminCartController.storeServices();
    vitaminCartController.fetchServices();
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
    final position = await getUserCurrentLocation();
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

                    vitaminCartController.stAddress.value = stAddress;
                    vitaminCartController.latitude.value = Latitude;
                    vitaminCartController.longitude.value = Longitude;

                    // vitaminCartController.setUserOrderInfo(
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
                    Get.to(() => VitaminServices(
                        address: stAddress,
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser));
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
