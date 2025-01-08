// ignore_for_file: prefer_final_fields, prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
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

  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.8846, 67.1754),
    zoom: 14.4746,
  );
  List<Marker> _marker = [];
  List<Marker> _list = [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(24.8846, 70.1754),
        infoWindow: InfoWindow(title: "Current Location".tr))
  ];
  String stAddress = '';
  String Latitude = " ";
  String Longitude = " ";
  bool address = false;
  final fireStore = FirebaseFirestore.instance.collection("User_appointments");

  @override
  void initState() {
    labController.storeServices();
    super.initState();
    _marker.addAll(_list);
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();
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
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () async {
            address = true;
            getUserCurrentLocation().then((value) async {
              print("My Location".tr);
              print(
                  value.latitude.toString() + " " + value.longitude.toString());
              _marker.add(Marker(
                  markerId: MarkerId("2"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(title: "My Location".tr)));
              Latitude = value.latitude.toString();
              Longitude = value.longitude.toString();

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  value.latitude, value.longitude);
              stAddress = placemarks.reversed.last.country.toString() +
                  " " +
                  placemarks.reversed.last.locality.toString() +
                  " " +
                  placemarks.reversed.last.street.toString();
              CameraPosition cameraPosition = CameraPosition(
                  zoom: 14,
                  target: LatLng(
                    value.latitude,
                    value.longitude,
                  ));
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            });
            Get.snackbar("To proceed".tr,
                "Kindly click on your address mentioned below".tr,
                duration: Duration(seconds: 5),
                backgroundColor: MyColors.logocolor,
                borderColor: Colors.black,
                borderWidth: 1);
          },
          child: Icon(Icons.navigation),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(children: [
          TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Confirm".tr,
                  middleText: "Are you sure you want to confirm".tr,
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onConfirm: () {
                    // setState(() {
                    //   fireStore.doc(user!.email).set({
                    //     "email": user.email,
                    //     "address": stAddress,
                    //     "type": "Doctor Visit"
                    //   });

                    // });

                    labController.stAddress.value = stAddress;
                    labController.latitude.value = Latitude;
                    labController.longitude.value = Longitude;

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
              child: Text(
                address
                    ? stAddress
                    : "Address will appear here when you press the button".tr,
                style: TextStyle(color: Colors.blue, fontSize: 15),
              )),
        ]),
      ),
    );
  }
}
