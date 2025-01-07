import 'package:flutter/material.dart';

class Service {
  final int id;
  final String imagePath;
  final LocalizedData localizedData;

  Service({
    required this.id,
    required this.imagePath,
    required this.localizedData,
  });

  // Factory method to create a Service from a Firestore document
  factory Service.fromFirestore(Map<String, dynamic> data, String languageCode) {
    return Service(
      id: data['id'],
      imagePath: data['imagePath'],
      localizedData: LocalizedData.fromMap(data['localized'][languageCode]),
    );
  }
}

class LocalizedData {
  final String serviceName;
  final String description;
  final String components;
  final String price;

  LocalizedData({
    required this.serviceName,
    required this.description,
    required this.components,
    required this.price,
  });

  // Factory method to create LocalizedData from a Map
  factory LocalizedData.fromMap(Map<String, dynamic> data) {
    return LocalizedData(
      serviceName: data['serviceName'],
      description: data['description'],
      components: data['components'],
      price: data['price'],
    );
  }
}
