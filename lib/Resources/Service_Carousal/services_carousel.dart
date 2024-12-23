// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/doctor_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/Vitamin_IV_drips_and_fluids.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class ServicesCarousel extends StatelessWidget {
    final UserModel userModel;
  final User firebaseUser;
  const ServicesCarousel({super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'color': Colors.blue[100],
        'icon': 'assets/images/lab.png',
        'text': 'Laboratory',
        'route': Laboratory(
          userModel: userModel,
          firebaseUser: firebaseUser,
        ),
      },
      {
        'color': Colors.blue[200],
        'icon': 'assets/images/doctor.png',
        'text': 'Doctor Visit',
        'route': DoctorVisit(),
      },
      {
        'color': Colors.blue[100],
        'icon': 'assets/images/nurse.png',
        'text': 'Nurse Visit',
        'route': NurseVisit(
          userModel: userModel,
          firebaseUser: firebaseUser,
        ),
      },
      {
        'color': Colors.blue[200],
        'icon': 'assets/images/vitamin.png',
        'text': 'Vitamin Drips',
        'route': Vitamin(
          userModel: userModel,
          firebaseUser: firebaseUser,
        ),
      },
    ];

    double cardSize = MediaQuery.of(context).size.width * 0.3;

    return CarouselSlider(
      options: CarouselOptions(
        height: cardSize,
        aspectRatio: 1.0,
        viewportFraction: 0.35,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
      ),
      items: services.map((service) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => service['route']),
                );
              },
              child: Container(
                width: cardSize,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: service['color'],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      service['icon'],
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      service['text'],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}