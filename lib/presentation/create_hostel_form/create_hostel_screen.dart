import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gecw_lakx/application/create_hostel_form/create_hostel_bloc.dart';
import 'package:gecw_lakx/presentation/success_page/success_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class CreateHostelScreen extends StatefulWidget {
  @override
  _CreateHostelScreenState createState() => _CreateHostelScreenState();
}

class _CreateHostelScreenState extends State<CreateHostelScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Text controllers
  TextEditingController hostelNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController roomsController = TextEditingController();
  TextEditingController personsPerRoomController = TextEditingController();
  TextEditingController vacancyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateHostelBloc, CreateHostelState>(
      listener: (context, state) {
        state.submitFailureOrSuccessOption.fold(() {}, (some) {
          some.fold((f) {
            final message = f.maybeWhen(
              serverError: () => "Some Error Occured, Try Again later",
              serviceUnavailable: () => "Service Unavailable",
              orElse: () => "Some Error Occured",
            );
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }, (s) {
            debugPrint("login success");

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => SuccessPage()));
          });
        });
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Create Hostel'),
            centerTitle: true,
            backgroundColor: Colors.teal,
            elevation: 5,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 10,
                        shadowColor: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              buildTextField(
                                controller: hostelNameController,
                                label: 'Hostel Name',
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: ownerNameController,
                                label: 'Owner Name',
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: phoneNumberController,
                                label: 'Phone Number',
                                inputType: TextInputType.phone,
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: rentController,
                                label: 'Rent and Mess Details',
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: roomsController,
                                label: 'Number of Rooms',
                                inputType: TextInputType.number,
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: personsPerRoomController,
                                label: 'Persons per Room',
                                inputType: TextInputType.number,
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: vacancyController,
                                label: 'Vacancy',
                                inputType: TextInputType.number,
                              ),
                              SizedBox(height: 12),
                              buildTextField(
                                controller: descriptionController,
                                label: 'Description',
                                maxLines: 3,
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                    ),
                                    onPressed: () => context
                                        .read<CreateHostelBloc>()
                                        .add(CreateHostelEvent
                                            .findLocationButtonPressed()),
                                    child: Text(
                                      'Get Location',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  if (state.locationFetched)
                                    Text(
                                      'Fetched!',
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20),
                              state.isSubmitting
                                  ? Center(
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator()),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<CreateHostelBloc>().add(
                                                  CreateHostelEvent
                                                      .submitButtonPressed(
                                                hostelName:
                                                    hostelNameController.text,
                                                ownerName:
                                                    ownerNameController.text,
                                                phoneNumber:
                                                    phoneNumberController.text,
                                                rent: rentController.text,
                                                rooms: roomsController.text,
                                                location: state.location,
                                                personsPerRoom:
                                                    personsPerRoomController
                                                        .text,
                                                vacancy: vacancyController.text,
                                                description:
                                                    descriptionController.text,
                                              ));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ).copyWith(
                                        minimumSize: WidgetStateProperty.all(
                                            Size(double.infinity,
                                                50)), // Full width and height
                                      ),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      keyboardType: inputType,
      maxLines: maxLines,
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
