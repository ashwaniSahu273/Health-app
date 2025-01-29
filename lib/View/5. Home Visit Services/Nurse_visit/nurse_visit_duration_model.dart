class NurseVisitDuration {
  final String duration;
  final String hours;
  final String price;

  NurseVisitDuration({
    required this.duration,
    required this.hours,
    required this.price,
  });

  // Convert object to JSON (for Firebase storage)
  Map<String, dynamic> toJson() {
    return {
      "duration": duration,
      "hours": hours,
      "price": price,
    };
  }

  // Create object from Firebase document snapshot
  factory NurseVisitDuration.fromJson(Map<String, dynamic> json) {
    return NurseVisitDuration(
      duration: json["duration"] ?? "",
      hours: json["hours"] ?? "",
      price: json["price"] ?? "",
    );
  }
}
