// To parse this JSON data, do
//
//     final hostelResponseModel = hostelResponseModelFromJson(jsonString);

import 'dart:convert';

HostelResponseModel hostelResponseModelFromJson(String str) => HostelResponseModel.fromJson(json.decode(str));

String hostelResponseModelToJson(HostelResponseModel data) => json.encode(data.toJson());

class HostelResponseModel {
  String description;
  String hostelName;
  String hostelId;
  Location location; // Nested Location object
  String ownerName;
  String distFromCollege;
  String isMessAvailable;
  String phoneNumber;
  String rent;
  String rooms;
  String vacancy;
  // List<String> hostelImages; // List of image URLs

  HostelResponseModel({
    required this.description,
    required this.hostelName,
    required this.location,
    required this.hostelId,
    required this.ownerName,
    required this.distFromCollege,
    required this.isMessAvailable,
    required this.phoneNumber,
    required this.rent,
    required this.rooms,
    required this.vacancy,
    // required this.hostelImages,
  });

  factory HostelResponseModel.fromJson(Map<String, dynamic> json) => HostelResponseModel(
        description: json["description"],
        hostelName: json["hostel_name"],
        hostelId: json['hostelId'],
        location: Location.fromJson(json["location"]),
        ownerName: json["owner_name"],
        distFromCollege: json["dist_from_college"],
        isMessAvailable: json["isMess_available"],
        phoneNumber: json["phone_number"],
        rent: json["rent"],
        rooms: json["rooms"],
        vacancy: json["vacancy"],
        // hostelImages: List<String>.from(json["hostel_images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "hostel_name": hostelName,
        "location": location.toJson(),
        "hostelId": hostelId,
        "owner_name": ownerName,
        "dist_from_college": distFromCollege,
        "isMess_available": isMessAvailable,
        "phone_number": phoneNumber,
        "rent": rent,
        "rooms": rooms,
        "vacancy": vacancy,
        // "hostel_images": List<dynamic>.from(hostelImages.map((x) => x)),
      };
}

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble() ?? 0.0,
        longitude: json["longitude"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
