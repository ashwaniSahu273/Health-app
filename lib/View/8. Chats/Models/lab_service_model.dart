class LabService {
  String id;
  String imagePath;
  Localized localized;
  String type;
  int? quantity; // Optional quantity field for use in the cart

  LabService({
    required this.type,
    required this.id,
    required this.imagePath,
    required this.localized,
    this.quantity, // Default is null unless explicitly set
  });

  // Factory constructor to create an instance from JSON
  factory LabService.fromJson(Map<String, dynamic> json) {
    return LabService(
      id: json['id'],
      imagePath: json['imagePath'],
      localized: Localized.fromJson(json['localized']),
      type: json['type'],
      quantity: 1, // Include quantity if it exists
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'localized': localized.toJson(),
      'quantity': quantity, // Include quantity in JSON representation
      'type': type
    };
  }
}

class Localized {
  ServiceDetails en;
  ServiceDetails ar;

  Localized({
    required this.en,
    required this.ar,
  });

  // Factory constructor to create an instance from JSON
  factory Localized.fromJson(Map<String, dynamic> json) {
    return Localized(
      en: ServiceDetails.fromJson(json['en']),
      ar: ServiceDetails.fromJson(json['ar']),
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'en': en.toJson(),
      'ar': ar.toJson(),
    };
  }
}

class ServiceDetails {
  String serviceName;
  String description;
  String instructions;
  String includesTests;
  String price;

  ServiceDetails({
    required this.includesTests,
    required this.serviceName,
    required this.description,
    required this.instructions,
    required this.price,
  });

  // Factory constructor to create an instance from JSON
  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      serviceName: json['serviceName'],
      description: json['description'],
      instructions: json['instructions'],
      includesTests: json['includesTests'],
      price: json['price'],
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'description': description,
      'Instructions': instructions,
      'price': price,
      'includesTests': includesTests,
    };
  }
}
