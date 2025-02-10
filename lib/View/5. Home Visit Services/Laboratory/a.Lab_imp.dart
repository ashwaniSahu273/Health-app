import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    target: LatLng(24.7136, 46.6753),
    zoom: 15.4746,
  );
  final List<Marker> _marker = [];
  String stAddress = '';
  String Latitude = " ";
  String Longitude = " ";
  bool address = false;
  bool isLoading = false;
  late Position position;
  final fireStore = FirebaseFirestore.instance.collection("User_appointments");

  void initState() {
    // vitaminCartController.fetchServices();
    // labController.storeServices();
    getCurrentLoc();
    super.initState();
  }

  void getCurrentLoc() async {
    setState(() {
      isLoading = true;
    });

    // Get the current position of the user
    position = await getUserCurrentLocation();
    setState(() {
      isLoading = false;
    });

    // After fetching position, update marker with current location
    _updateMarker(position.latitude, position.longitude);

    // Move camera to the current position
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newLatLng(
      LatLng(position.latitude, position.longitude),
    ));
  }

  // Future<void> _handleTap(LatLng tappedPoint) async {
  //   final GoogleMapController mapController = await _controller.future;

  //   // Animate to tapped location
  //   mapController.animateCamera(CameraUpdate.newLatLng(tappedPoint));

  //   // Address fetching and marker updates
  //   setState(() {
  //     stAddress = "Fetching address...";
  //     Latitude = tappedPoint.latitude.toString();
  //     Longitude = tappedPoint.longitude.toString();

  //     _marker.clear();
  //     _marker.add(Marker(
  //       markerId: const MarkerId("selectedLocation"),
  //       position: tappedPoint,
  //       infoWindow: InfoWindow(title: "Selected Location"),
  //     ));
  //   });

  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         tappedPoint.latitude, tappedPoint.longitude);

  //     setState(() {
  //       stAddress =
  //           "${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}";
  //     });
  //   } catch (e) {
  //     setState(() {
  //       stAddress = "Failed to fetch address. Try again.";
  //     });
  //   }
  // }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();
  }

  void _showAddressBottomSheet() async {
    if (isLoading) return; // Prevent multiple clicks during the process

    setState(() {
      isLoading = true;
    });

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

    setState(() {
      isLoading = false;
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
                if (isLoading) return; // Prevent clicking while loading

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

                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Close the bottom sheet

                    Get.to(LabTest(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                      address: stAddress,
                    ));
                  },
                  textCancel: "Cancel".tr,
                  textConfirm: "Confirm".tr,
                );
              },
              child: Text("Send".tr),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isDismissible: true,
    );
  }

  void _updateMarker(double lat, double lng) {
    setState(() {
      _marker.clear();
      _marker.add(Marker(
        markerId: const MarkerId("currentLocation"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: "Current Location"),
      ));
    });
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
          // onTap: _handleTap,
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: MyRoundButton(
          text: isLoading
              ? "Loading..."
              : "Select Location".tr, // Button text change during loading
          onTap: _showAddressBottomSheet,
        ),
      ),
    );
  }
}
