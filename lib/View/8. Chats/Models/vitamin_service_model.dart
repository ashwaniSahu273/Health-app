class Service {
  int id;
  String imagePath;
  Localized localized;
  int? quantity; // Optional quantity field for use in the cart

  Service({
    required this.id,
    required this.imagePath,
    required this.localized,
    this.quantity, // Default is null unless explicitly set
  });

  // Factory constructor to create an instance from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      imagePath: json['imagePath'],
      localized: Localized.fromJson(json['localized']),
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
  String price;

  ServiceDetails({
    required this.serviceName,
    required this.description,
    required this.components,
    required this.price,
  });

  // Factory constructor to create an instance from JSON
  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      serviceName: json['serviceName'],
      description: json['description'],
      components: json['components'],
      price: json['price'],
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'description': description,
      'components': components,
      'price': price,
    };
  }
}
