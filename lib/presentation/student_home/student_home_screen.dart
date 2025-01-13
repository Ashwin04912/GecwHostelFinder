import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gecw_lakx/application/hostel_process/owner_home/owner_home_bloc.dart';
import 'package:gecw_lakx/domain/hostel_process/hostel_resp_model.dart';
import 'package:gecw_lakx/presentation/hostel_details/hostel_details_student_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  List<HostelResponseModel>? hostelResponseModel;
  List<HostelResponseModel>? allHostels; // Backup for the original list
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadHostels();
  }

  Future<void> _loadHostels() async {
    context.read<OwnerHomeBloc>().add(OwnerHomeEvent.getAllHostelList());
  }

  void _openFilterModal() {
    double _minFees = 0;
    double _maxFees = 5000;
    double _selectedRating = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Options",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hostel Fees Filter
                  const Text(
                    "Hostel Fees (₹):",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  RangeSlider(
                    values: RangeValues(_minFees, _maxFees),
                    min: 0,
                    max: 10000,
                    divisions: 20,
                    labels: RangeLabels(
                        '₹${_minFees.round()}', '₹${_maxFees.round()}'),
                    onChanged: (values) {
                      setModalState(() {
                        _minFees = values.start;
                        _maxFees = values.end;
                      });
                    },
                    activeColor: Colors.deepPurpleAccent,
                    inactiveColor: Colors.white30,
                  ),
                  const SizedBox(height: 20),

                  // Rating Filter
                  const Text(
                    "Minimum Rating:",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Slider(
                    value: _selectedRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _selectedRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedRating = value;
                      });
                    },
                    activeColor: Colors.amber,
                    inactiveColor: Colors.white30,
                  ),
                  const SizedBox(height: 20),

                  // Apply Filters Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          hostelResponseModel = allHostels?.where((hostel) {
                            try {
                              final rent = double.parse(hostel.rent);
                              return rent >= _minFees &&
                                  rent <=
                                      _maxFees; // Add rating filter here if needed
                            } catch (e) {
                              return false;
                            }
                          }).toList();
                        });
                        Navigator.pop(context); // Close modal
                      },
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching || hostelResponseModel != allHostels) {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            _searchQuery = "";
            hostelResponseModel = allHostels; // Reset to full list
          });
          return false; // Prevent the default back navigation
        }
        return true; // Allow back navigation if no filters/search active
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[850],
          elevation: 0,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search for a hostel...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                )
              : const Text(
                  'GecW Hostel Finder',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.clear : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                    _searchQuery = "";
                    hostelResponseModel = allHostels; // Reset list
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: _openFilterModal,
            ),
          ],
        ),
        body: BlocConsumer<OwnerHomeBloc, OwnerHomeState>(
          listener: (context, state) {
            state.hostelGetFailureOrSuccess.fold(() {}, (either) {
              either.fold((failure) {
                final message = failure.maybeWhen(
                  serviceUnavailable: () =>
                      "Service unavailable. Try again later.",
                  orElse: () => "An error occurred. Please try again.",
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }, (hostels) {
                setState(() {
                  allHostels = hostels;
                  hostelResponseModel = hostels;
                });
              });
            });
          },
          builder: (context, state) {
            if (hostelResponseModel == null) {
              return const Center(
                child:
                    CircularProgressIndicator(color: Colors.deepPurpleAccent),
              );
            }

            final filteredHostels = hostelResponseModel!
                .where((hostel) => hostel.hostelName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

            if (filteredHostels.isEmpty) {
              return const Center(
                child: Text(
                  "No hostels found.",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filteredHostels.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final hostel = filteredHostels[index];
                return GestureDetector(
                  onTap: () async{
                   final SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? userId = prefs.getString("owner_userid");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HostelDetailsStudentAppScreen(
                              hostelName: hostel.hostelName,
                              ownerName: hostel.ownerName,
                              mess: "Available",
                              phNumber: hostel.phoneNumber,
                              rent: hostel.rent,
                               hostelId: hostel.hostelId,
                               userId: userId.toString(), hostelImage: hostel.hostelImages,
                            )));
                  },
                  child: Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            hostel.hostelImages[0],
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hostel.hostelName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                hostel.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: '₹${hostel.rent}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' /month',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber, size: 20),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.5',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
