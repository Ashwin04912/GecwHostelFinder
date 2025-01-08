// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:gecw_lakx/domain/hostel_process/hostel_resp_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<Either<FormFailures, Unit>> saveDataToDb(
      {required String hostelName,
      required String ownerName,
      required String phoneNumber,
      required String rent,
      required String rooms,
      required String personsPerRoom,
      required Position location,
      required String vacancy,
      required String description}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? userId = prefs.getString('owner_userid');
      final firebaseDb = await fireStore;

      Map<String, dynamic> hostelData = {
        'hostel_name': hostelName,
        'owner_name': ownerName,
        'phone_number': phoneNumber,
        'description': description,
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
        'rent': rent,
        'rooms': rooms,
        'persons_per_room': personsPerRoom,
        'vacancy': vacancy,
      };
      DocumentReference doc = await firebaseDb
          .collection('hostels')
          .doc(userId)
          .collection('my_hostels')
          .add(hostelData);
      await firebaseDb.collection('all_hostelList').add(hostelData);

      debugPrint('Document added with ID: ${doc.id}');
      return right(unit);
    } on FirebaseException catch (e) {
      // Firestore-specific error
      debugPrint("FirebaseException: ${e.message}");
      return left(const FormFailures.serverError());
    } catch (e) {
      // General error
      debugPrint("An error occurred: $e");
      return left(const FormFailures.serviceUnavailable());
    }
  }

  @override
  Future<Either<FormFailures, List<HostelResponseModel>>>
      getAllHostelList() async {
    try {
      // Reference to the `all_hostelList` collection
      final CollectionReference hostelCollection =
          FirebaseFirestore.instance.collection('all_hostelList');

      // Fetch all documents from the `all_hostelList` collection
      QuerySnapshot querySnapshot = await hostelCollection.get();

      // Check if any documents exist
      if (querySnapshot.docs.isEmpty) {
        return left(const FormFailures.noDataFound());
      }

      // Convert each document into a HostelResponseModel
      List<HostelResponseModel> hostels = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return HostelResponseModel.fromJson(data);
      }).toList();

      // Return the list of hostels
      return right(hostels);
    } catch (e) {
      // Log and return a server failure in case of exceptions
      print("Error fetching all hostel list: $e");
      return left(const FormFailures.serverError());
    }
  }

  @override
  Future<Either<FormFailures, List<HostelResponseModel>>> getOwnerHostelList(
      {required String userId}) async {
    try {
      print("api requesting uid $userId");
      // Reference to the 'myhostel' subcollection for the specific user
      final CollectionReference<Map<String, dynamic>> hostelCollection =
          FirebaseFirestore.instance
              .collection('hostels')
              .doc(userId)
              .collection('my_hostels')
              .withConverter<Map<String, dynamic>>(
                fromFirestore: (snapshot, _) => snapshot.data()!,
                toFirestore: (data, _) => data,
              );

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await hostelCollection.get();
      final hostels = querySnapshot.docs.map((doc) {
        return HostelResponseModel.fromJson(doc.data());
      }).toList();

      debugPrint(hostels.toString());

      // debugPrint(hostelCollection.toString());

      // Check if any documents exist
      if (querySnapshot.docs.isEmpty) {
        return left(const FormFailures.noDataFound());
      }

      // Convert each document into a HostelResponseModel

      // Return the list of hostels
      return right(hostels);
    } catch (e) {
      // Log and return a server failure in case of exceptions
      print("Error fetching owner hostel list: $e");
      return left(const FormFailures.serverError());
    }
  }
}
