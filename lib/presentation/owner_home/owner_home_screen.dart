import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gecw_lakx/application/hostel_process/owner_home/owner_home_bloc.dart';
import 'package:gecw_lakx/domain/hostel_process/hostel_resp_model.dart';
import 'package:gecw_lakx/presentation/hostel_details/hostel_details_owner_app_screen.dart';
import 'package:gecw_lakx/presentation/hostel_process/create_hostel_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  List<HostelResponseModel>? hostelResponseModel;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? ownerUserId;
  bool? noHostelDataPresent;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchHostels();
  }

  Future<void> _loadUserIdAndFetchHostels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('owner_userid');

    setState(() {
      ownerUserId = userId;
    });

    if (userId != null) {
      context
          .read<OwnerHomeBloc>()
          .add(OwnerHomeEvent.getOwnersHostelList(userId: userId.toString()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data found. Please log in again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search your hostel',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'My Hostels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Manage your properties with ease',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                ],
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
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<OwnerHomeBloc, OwnerHomeState>(
        listener: (context, state) {
          state.hostelGetFailureOrSuccess.fold(() {}, (either) {
            either.fold((failure) {
              failure.maybeWhen(
                noDataFound: () {
                  setState(() {
                    noHostelDataPresent = true;
                  });
                },
                orElse: () {},
              );
              String? message = failure.maybeWhen(
                  serviceUnavailable: () =>
                      "Service is currently unavailable. Try again later.",
                  orElse: () => "An unexpected error occurred.",
                  noDataFound: () => null);
              if (message != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
            }, (hostels) {
              setState(() {
                hostelResponseModel = hostels;
              });
            });
          });
        },
        builder: (context, state) {
          if (hostelResponseModel == null && noHostelDataPresent != true) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          if (noHostelDataPresent == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hotel,
                    size: 80,
                    color: Colors.deepPurpleAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Hostels Found",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "It seems like you haven't added any hostels yet.\nTap the button below to get started.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateHostelScreen()));
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Add Hostel",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
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
                "No hostels found matching your search.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF232A34), Color(0xFF1A1A2E)],
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: filteredHostels.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final hostel = filteredHostels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HostelDetailsOwnerAppScreen(
                              hostelId: hostel.hostelId,
                              hostelImages: hostel.hostelImages,
                            )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF2B2B40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            height: 150,
                            imageUrl: hostel.hostelImages[0],
                            width: MediaQuery.of(context).size.width - 40,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[850],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white70,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      hostel.hostelName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      const SizedBox(width: 5),
                                      Text(
                                        '20',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hostel.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 12),
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
                                          text: ' / month',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HostelDetailsOwnerAppScreen(
                                                    hostelId: hostel.hostelId,
                                                    hostelImages:
                                                        hostel.hostelImages,
                                                  )));
                                    },
                                    child: const Text(
                                      "View Details",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
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
            ),
          );
        },
      ),
    );
  }
}
