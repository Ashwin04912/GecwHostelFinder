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
String isMensHostel;
  String phoneNumber;
  String rent;
  String rooms;
  String vacancy;
  List<String> hostelImages; // List of image URLs
  String hostelOwnerUserId;

  HostelResponseModel({
    required this.description,
    required this.hostelName,
    required this.location,
    required this.hostelId,
    required this.ownerName,
    required this.distFromCollege,
    required this.isMessAvailable,
required this.isMensHostel,
    required this.phoneNumber,
    required this.rent,
    required this.rooms,
    required this.vacancy,
    required this.hostelImages,
    required this.hostelOwnerUserId,
  });

  factory HostelResponseModel.fromJson(Map<String, dynamic> json) => HostelResponseModel(
        description: json["description"],
        hostelName: json["hostel_name"],
        hostelId: json['hostelId'],
        location: Location.fromJson(json["location"]),
        ownerName: json["owner_name"],
        distFromCollege: json["dist_from_college"],
        isMessAvailable: json["isMess_available"],
isMensHostel:json["isMensHostel"], 
        phoneNumber: json["phone_number"],
        rent: json["rent"],
        rooms: json["rooms"],
        vacancy: json["vacancy"],
        hostelImages: List<String>.from(json["imageList"].map((x) => x)),
        hostelOwnerUserId: json['hostelOwnerUserId']
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "hostel_name": hostelName,
        "location": location.toJson(),
        "hostelId": hostelId,
        "owner_name": ownerName,
        "dist_from_college": distFromCollege,
        "isMess_available": isMessAvailable,
"isMensHostel":isMensHostel,
        "phone_number": phoneNumber,
        "rent": rent,
        "rooms": rooms,
        "vacancy": vacancy,
        "imageList": List<dynamic>.from(hostelImages.map((x) => x)),
        "hostelOwnerUserId" : hostelOwnerUserId
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
