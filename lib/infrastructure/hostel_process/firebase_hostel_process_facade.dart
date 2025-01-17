import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:gecw_lakx/domain/hostel_process/hostel_resp_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:gecw_lakx/domain/core/formfailures.dart';
import 'package:gecw_lakx/domain/core/location_fetch_failures.dart';
import 'package:gecw_lakx/domain/hostel_process/i_hostel_process_facade.dart';

@LazySingleton(as: IHostelProcessFacade)
class FirebaseHostelProcessFacade extends IHostelProcessFacade {
  FirebaseFirestore fireStore;
  FirebaseHostelProcessFacade({
    required this.fireStore,
  });

  @override
  Future<Either<LocationFetchFailures, Position>> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      debugPrint('Location services are disabled.');
      return left(LocationFetchFailures.locationServiceDisabled());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("location access denied");
        left(LocationFetchFailures.LocationPermissionDenied());
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return right(position);
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        debugPrint("Location services are disabled.");
        return left(LocationFetchFailures.locationServiceDisabled());
      } else if (e is PermissionDeniedException) {
        debugPrint("Location permissions are denied.");
        return left(LocationFetchFailures.LocationPermissionDenied());
      } else {
        debugPrint("Failed to get location: $e");
      }
      return left(LocationFetchFailures.networkError());
    }
  }

  @override
  Future<Either<FormFailures, Unit>> saveDataToDb({
    required String hostelName,
    required String ownerName,
    required String phoneNumber,
    required String rent,
    required String rooms,
    required Position location,
    required String vacancy,
    required String distFromCollege,
    required String isMessAvailable,
    required List<XFile> hostelImages,
    required String description,
  }) async {
    try {
      print("In API call: $distFromCollege and $isMessAvailable");

      // Retrieve user ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('owner_userid');

      if (userId == null || userId.isEmpty) {
        debugPrint("User ID is null or empty");
        return left(const FormFailures.serviceUnavailable());
      }

      // Initialize Firestore
      final firebaseDb = FirebaseFirestore.instance;

      // Upload images and get the URLs
      final imageListResult =
          await uploadHostelImages(hostelImages: hostelImages);
      late List<String> imageUrls;

      imageListResult.fold(
        (failure) {
          debugPrint("Image upload failed: $failure");
          return left(const FormFailures.serverError());
        },
        (urls) {
          imageUrls = urls;
        },
      );

      if (imageUrls.isEmpty) {
        debugPrint("No images uploaded successfully");
        return left(const FormFailures.serverError());
      }

      final String hostelId = Uuid().v1();

      // Prepare hostel data
      final hostelData = {
        'hostelOwnerUserId': userId,
        'hostel_name': hostelName,
        'hostelId': hostelId,
        'owner_name': ownerName,
        'phone_number': phoneNumber,
        'description': description,
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
        'dist_from_college': distFromCollege,
        'isMess_available': isMessAvailable,
        'rent': rent,
        'rooms': rooms,
        'vacancy': vacancy,
        'imageList': imageUrls,
      };

      // Save hostel data to Firestore
      await firebaseDb
          .collection('my_hostels')
          .doc(userId)
          .collection('hostels')
          .doc(hostelId)
          .set(hostelData);

      await firebaseDb
          .collection('all_hostel_list')
          .doc(hostelId)
          .set(hostelData);

      debugPrint('Document added with ID: $hostelId');
      return right(unit);
    } on FirebaseException catch (e) {
      debugPrint("FirebaseException [${e.code}]: ${e.message}");
      return left(const FormFailures.serverError());
    } catch (e) {
      debugPrint("An unexpected error occurred: $e");
      return left(const FormFailures.serviceUnavailable());
    }
  }

  @override
Future<Either<FormFailures, List<HostelResponseModel>>>
    getAllHostelList() async {
  try {
    // Reference the collection
    final CollectionReference hostelCollection =
        FirebaseFirestore.instance.collection('all_hostel_list');

    // Query the collection
    QuerySnapshot querySnapshot = await hostelCollection.get();

    // Check if the collection is empty
    if (querySnapshot.docs.isEmpty) {
      debugPrint("No data found in all_hostel_list collection");
      return left(const FormFailures.noDataFound());
    }

    // Map the querySnapshot to the list of HostelResponseModel
    List<HostelResponseModel> hostels = querySnapshot.docs.map((doc) {
      // Safely parse document data
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return HostelResponseModel.fromJson(data);
    }).toList();

    debugPrint("Fetched hostels: $hostels");

    return right(hostels);
  } catch (e) {
    // Handle any exceptions
    debugPrint("Error fetching all hostel list: $e");

    // If the error might be related to a missing collection
    if (e.toString().contains('Null is not a subtype of type')) {
      debugPrint("Likely cause: Collection does not exist or has no data.");
      return left(const FormFailures.noDataFound());
    }

    return left(const FormFailures.serverError());
  }
}


  @override
  Future<Either<FormFailures, List<HostelResponseModel>>> getOwnerHostelList(
      {required String userId}) async {
    try {
      debugPrint("api requesting uid $userId");
      // Reference to the 'myhostel' subcollection for the specific user
      final CollectionReference<Map<String, dynamic>> hostelCollection =
          FirebaseFirestore.instance
              .collection('my_hostels')
              .doc(userId)
              .collection('hostels');

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await hostelCollection.get();
      final hostels = querySnapshot.docs.map((doc) {
        return HostelResponseModel.fromJson(doc.data());
      }).toList();

      debugPrint("i got hostels${hostels.toString()}");
      if (querySnapshot.docs.isEmpty) {
        print("no data found");
        return left(const FormFailures.noDataFound());
      }
      return right(hostels);
    } catch (e) {
      // Log and return a server failure in case of exceptions
      debugPrint("Error fetching owner hostel list: $e");
      return left(const FormFailures.serverError());
    }
  }

  @override
  Future<Either<FormFailures, Unit>> rateTheHostel({
    required String hostelId,
    required String star,
    required String comment,
    required String userId,
    required String userName,
  }) async {
    try {
      // Create a new rating object
      final rating = {
        'userId': userId,
        'userName': userName,
        'stars': star,
        'comment': comment,
      };

      await fireStore
          .collection('hostel_rating')
          .doc(hostelId)
          .collection('ratings')
          .add(rating);

      debugPrint("rating added successfully");

      return right(unit);
    } catch (e) {
      debugPrint('Error rating hostel: $e');
      return left(FormFailures.serverError());
    }
  }

  @override
  Future<Either<FormFailures, List<Map<String, String>>>>
      getAllratingsAndReview({
    required String hostelId,
  }) async {
    debugPrint("hostel id = $hostelId");
    try {
      // Reference to the Firestore collection
      final reviewCollection = FirebaseFirestore.instance
          .collection('hostel_rating')
          .doc(hostelId)
          .collection('ratings');

      // Fetch the reviews
      final querySnapshot = await reviewCollection.get();

      // Process the reviews into a structured format
      final reviews = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'comment': data["comment"] as String,
          'stars': data["stars"] as String,
          'userId': data["userId"] as String,
          'userName': data["userName"] as String,
        };
      }).toList();
      print(reviews);

      return right(reviews); // Return the list of reviews in the correct format
    } catch (e) {
      // Log the error and return a server error
      debugPrint('Error fetching reviews: $e');
      return left(FormFailures.serverError());
    }
  }

  @override
  Future<Either<FormFailures, List<String>>> uploadHostelImages({
    required List<XFile> hostelImages,
  }) async {
    try {
      final supabase = SupabaseClient(
        'https://mksxoiizgunbatwgjgru.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rc3hvaWl6Z3VuYmF0d2dqZ3J1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY3NDUwODMsImV4cCI6MjA1MjMyMTA4M30.flRm8k5nPQOoi1F63dZaL-BLvZXMLoP14cEpPur0mzA',
      );

      List<String> imageUrls = [];

      // Upload each file and store the public URL
      for (int i = 0; i < hostelImages.length; i++) {
        final file = File(hostelImages[i].path);
        final fileName =
            'images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

        try {
          // Upload the file
          await supabase.storage.from('hostel_images').upload(
                fileName,
                file,
                fileOptions: const FileOptions(upsert: true),
              );

          // Get the public URL of the uploaded file
          final publicUrl =
              supabase.storage.from('hostel_images').getPublicUrl(fileName);
          if (publicUrl.isNotEmpty) {
            imageUrls.add(publicUrl);
          } else {
            debugPrint("Failed to get public URL for $fileName");
            return left(FormFailures.serverError());
          }
        } catch (e) {
          debugPrint("Upload failed for $fileName: ${e.toString()}");
          return left(FormFailures.serverError());
        }
      }

      return right(imageUrls);
    } catch (e) {
      debugPrint("Image uploading exception: ${e.toString()}");
      return left(FormFailures.serverError());
    }
  }
}
