import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gecw_lakx/application/hostel_process/create_hostel/create_hostel_bloc.dart';
import 'package:gecw_lakx/presentation/bottom_navigation/bottom_navigation_owner.dart';

class CreateHostelScreen extends StatefulWidget {
  const CreateHostelScreen({super.key});

  @override
  _CreateHostelScreenState createState() => _CreateHostelScreenState();
}

class _CreateHostelScreenState extends State<CreateHostelScreen> {
  final _formKey = GlobalKey<FormState>();

  // Firestore instance
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Text controllers
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController hostelNameController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController vacancyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController messAvailableController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();

  // Image picker
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateHostelBloc, CreateHostelState>(
      listener: (context, state) {
        state.submitFailureOrSuccessOption.fold(() {}, (some) {
          some.fold((failure) {
            final message = failure.maybeWhen(
              serverError: () => "Server Error, Please try again later",
              serviceUnavailable: () => "Service Unavailable",
              orElse: () => "An unexpected error occurred",
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }, (success) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (ctx) => BottomNavigationBarOwnerWidget(),
              ),
              (route) => false,
            );
          });
        });
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading:true,
            foregroundColor: Colors.white,
            title: const Text('Create Hostel'),
            backgroundColor: const Color(0xFF1F1F1F),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(ownerNameController, 'Owner Name'),
                    const SizedBox(height: 12),
                    _buildTextField(phoneNumberController, 'Phone Number',
                        inputType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField(hostelNameController, 'Hostel Name'),
                    const SizedBox(height: 12),
                    _buildTextField(rentController, 'Rent',inputType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField(roomsController, 'Number of Rooms',
                        inputType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField(distanceController, 'Distance from College (in meter)',
                        inputType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField(vacancyController, 'Vacancy',
                        inputType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      messAvailableController,
                      'Is Mess Available? (Yes/No)',
                      ['Yes', 'No'],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(descriptionController, 'Description',
                        maxLines: 3),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context.read<CreateHostelBloc>().add(
                              CreateHostelEvent.findLocationButtonPressed()),
                          child: Text(
                            'Get Location',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        if (state.locationFetched)
                          Text(
                            'Location Fetched!',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedImages = await _picker.pickMultiImage();
                        setState(() {
                          _imageFiles = pickedImages ?? [];
                        });
                      },
                      child: const Text('Pick Images'),
                    ),
                    const SizedBox(height: 12),
                    _imageFiles!.isEmpty
                        ? const Text('No images selected',
                            style: TextStyle(color: Colors.white70))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _imageFiles!.length,
                            itemBuilder: (context, index) {
                              return Image.file(
                                File(_imageFiles![index].path),
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Image upload logic
                          List<String> imageUrls = [];
                          if (_imageFiles != null && _imageFiles!.isNotEmpty) {
                            for (var file in _imageFiles!) {
                              try {
                                final imageKitResponse = await ImageKit.io(
                                  File(file.path) as List<int>,
                                  privateKey:
                                      "private_esKt2hGQTPqCHER2j06jgmmFdWQ=", // Replace with your private key
                                  fileName: file.name,
                                  onUploadProgress: (double progressValue) {},
                                );
                                if (imageKitResponse.url != null) {
                                  imageUrls.add(imageKitResponse.url!);
                                }
                              } catch (e) {
                                print("Error uploading image: $e");
                              }
                            }
                          }

                          // Dispatching the event to the Bloc
                          context.read<CreateHostelBloc>().add(
                                CreateHostelEvent.submitButtonPressed(
                                  hostelName: hostelNameController.text,
                                  ownerName: ownerNameController.text,
                                  phoneNumber: phoneNumberController.text,
                                  rent: rentController.text,
                                  rooms: roomsController.text,
                                  vacancy: vacancyController.text,
                                  description: descriptionController.text,
                                  location: state.location,
                                  personsPerRoom: '',
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF121212),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == "Phone Number" && value.length < 10) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(
    TextEditingController controller,
    String label,
    List<String> options,
  ) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dropdownColor: Colors.grey[850],
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          controller.text = value ?? '';
        });
      },
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }
}
