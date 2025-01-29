class NurseServiceModel {
  String id;
  String imagePath;
  Localized localized;
  String? type;
    int? quantity;

  NurseServiceModel({
    this.type,
    required this.id,
    required this.imagePath,
    required this.localized,
     this.quantity,
  });

  // Factory constructor to create an instance from JSON
  factory NurseServiceModel.fromJson(Map<String, dynamic> json) {
    return NurseServiceModel(
      id: json['id'] ?? '', // Default to an empty string if null
      imagePath: json['imagePath'],
      localized: Localized.fromJson(json['localized']),
      type: json['type'],
      quantity: 1
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'localized': localized.toJson(),
      'quantity': quantity,
      'type':type
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
  String about;
  String serviceIncludes;
  String termsOfService;
  String price;

  ServiceDetails({
    required this.serviceName,
    required this.description,
    required this.about,
    required this.serviceIncludes,
    required this.termsOfService,
    required this.price,
  });

  // Factory constructor to create an instance from JSON
  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      about: json['about'] ?? '',
      serviceIncludes: json['serviceIncludes'] ?? '',
      termsOfService: json['TermsOfService'] ?? '',
      price: json['price'] ?? '',
    );
  }

  // Method to convert the object into a map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'description': description,
      'about': about,
      'serviceIncludes': serviceIncludes,
      'TermsOfService': termsOfService,
      'price': price,
    };
  }
}
