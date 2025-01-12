import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gecw_lakx/application/hostel_process/owner_home/owner_home_bloc.dart';
import 'package:gecw_lakx/domain/hostel_process/hostel_resp_model.dart';
import 'package:gecw_lakx/presentation/hostel_details/hostel_details_owner_app_screen.dart';
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Manage your properties',
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
            icon: _isSearching
                ? const Icon(Icons.clear, color: Colors.white)
                : const Icon(Icons.search, color: Colors.white),
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
              final message = failure.maybeWhen(
                serviceUnavailable: () => "Try again later",
                orElse: () => "An error occurred",
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            }, (hostels) {
              setState(() {
                hostelResponseModel = hostels;
              });
            });
          });
        },
        builder: (context, state) {
          if (hostelResponseModel == null || hostelResponseModel!.isEmpty) {
            return const Center(
              child: Text(
                "No hostels found.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            );
          }

          final filteredHostels = hostelResponseModel!
              .where((hostel) => hostel.hostelName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF232A34), Color(0xFF1A1A2E)],
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: filteredHostels.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final hostel = filteredHostels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HostelDetailsOwnerAppScreen(
                              hostelId: hostel.hostelId,
                            )));
                  },
                  child: Container(
                    width: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF2B2B40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            "https://content.jdmagicbox.com/comp/ghaziabad/w4/011pxx11.xx11.191217190807.e5w4/catalogue/rpn-boy-s-hostel-dasna-ghaziabad-hostels-adyayiouqi.jpg",
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '(12)',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70,
                                      ),
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
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    text: '${hostel.rent}/-',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: '  /month',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
