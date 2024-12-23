// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentCarousel extends StatelessWidget {
  final Stream<QuerySnapshot> userAppointments;

  const AppointmentCarousel({super.key, required this.userAppointments});

  @override
  Widget build(BuildContext context) {
    final List<Gradient> gradients = [
      LinearGradient(
        colors: [Color.fromARGB(255, 82, 177, 255), Color.fromARGB(255, 149, 207, 255)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      LinearGradient(
        colors: [Color.fromARGB(255, 255, 255, 172), Color.fromARGB(255, 252, 252, 220)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      LinearGradient(
        colors: [Colors.purple, Colors.deepPurpleAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ];

    return StreamBuilder<QuerySnapshot>(
      stream: userAppointments,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No pending appointments"));
        }

        return CarouselSlider.builder(
          options: CarouselOptions(
            height: 200.0,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index, realIdx) {
            var appointment = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: gradients[index % gradients.length],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              appointment['email'].toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                appointment['address'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: Colors.black,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              appointment['type'].toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}