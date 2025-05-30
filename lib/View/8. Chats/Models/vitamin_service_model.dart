class Service {
  String id;
  String imagePath;
  Localized localized;
  String type;
  int? quantity; // Optional quantity field for use in the cart
  String? createdAt;

  Service({
    required this.id,
    required this.type,
    required this.imagePath,
    required this.localized,
    this.createdAt,
    this.quantity, // Default is null unless explicitly set
  });

  // Factory constructor to create an instance from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      imagePath: json['imagePath'],
      localized: Localized.fromJson(json['localized']),
      type: json['type'],
      quantity: 1, // Include quantity if it exists
      createdAt: json['createdAt'],
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'localized': localized.toJson(),
      'quantity': quantity, // Include quantity in JSON representation
      'type': type,
      'createdAt': createdAt
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
  String components;
  String instructions;
  String price;

  ServiceDetails({
    required this.serviceName,
    required this.description,
    required this.components,
    required this.instructions,
    required this.price,
  });

  // Factory constructor to create an instance from JSON
  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      serviceName: json['serviceName'],
      description: json['description'],
      components: json['components'],
      instructions: json['instructions'],
      price: json['price'],
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'description': description,
      'components': components,
      'instructions': instructions,
      'price': price,
    };
  }
}
