import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gecw_lakx/application/hostel_process/common_hostel_process/common_hostel_process_bloc.dart';
import 'package:gecw_lakx/presentation/chat/chat_page.dart';
import 'package:gecw_lakx/presentation/hostel_details/widgets/build_detail_widget.dart';
import 'package:gecw_lakx/presentation/hostel_details/widgets/build_review_widget.dart';
import 'package:url_launcher/url_launcher.dart';

@immutable
class HostelDetailsStudentAppScreen extends StatefulWidget {
  final String hostelName;
  final String hostelOwnerUserId;
  final String ownerName;
  final String phNumber;
  final String rent;
  final String mess;
  final String hostelId;
  final String userId;
  final List<String> hostelImage;

  const HostelDetailsStudentAppScreen({
    super.key,
    required this.hostelName,
    required this.ownerName,
    required this.phNumber,
    required this.rent,
    required this.mess,
    required this.hostelId,
    required this.userId,
    required this.hostelImage,
    required this.hostelOwnerUserId,
  });

  @override
  HostelDetailsStudentAppScreenState createState() =>
      HostelDetailsStudentAppScreenState();
}

class HostelDetailsStudentAppScreenState
    extends State<HostelDetailsStudentAppScreen> {
  double _userRating = 4.0; // Default rating
  List<Map<String, String>> reviews = [];

  // Room and bed data
  final List<Map<String, dynamic>> rooms = [
    {
      'roomNumber': 101,
      'beds': [true, false, true, true]
    },
    {
      'roomNumber': 102,
      'beds': [false, false, true, true]
    },
    {
      'roomNumber': 103,
      'beds': [true, true, true, false]
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<CommonHostelProcessBloc>().add(
        CommonHostelProcessEvent.getAllratingsAndReview(
            hostelId: widget.hostelId));
  }

  void _openAddReviewModal() {
    final TextEditingController reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rate and Review",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: _userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _userRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write your review here...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.deepPurpleAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (reviewController.text.trim().isNotEmpty) {
                          setState(() {
                            reviews.add({
                              'rating': _userRating.toString(),
                              'review': reviewController.text.trim(),
                            });
                          });
                          context.read<CommonHostelProcessBloc>().add(
                                  CommonHostelProcessEvent
                                      .submitReviewButtonPressed(
                                stars: _userRating.toString(),
                                userId: widget.userId,
                                userName: "Anonymous",
                                comment: reviewController.text.trim(),
                                hostelId: widget.hostelId,
                              ));
                          Navigator.pop(context);
                          context.read<CommonHostelProcessBloc>().add(
                              CommonHostelProcessEvent.getAllratingsAndReview(
                                  hostelId: widget.hostelId));
                        }
                      },
                      child: const Text(
                        "Submit Review",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
        title: Text(
          widget.hostelName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () async {
                  final phoneNumber =
                      widget.phNumber; // Use your desired phone number
                  final url = 'tel:$phoneNumber';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    // Handle the error if the URL can't be launched
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not launch the phone dialer.'),
                      ),
                    );
                  }
                },
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  // Chat button functionality
                  _handlePressed(
                      types.User(id: widget.hostelOwnerUserId), context);
                },
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<CommonHostelProcessBloc, CommonHostelProcessState>(
        listener: (context, state) {
          state.getAllRatingsSuccessOrFailure.fold(() {}, (either) {
            either.fold((f) {}, (s) {
              setState(() {
                reviews = s;
              });
            });
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Horizontal Photo Scroller
                      _buildPhotoScroller(),
                      const SizedBox(height: 20),
                      // Hostel Details Section
                      _buildDetailsSection(),
                      const SizedBox(height: 25),
                      reviews.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("No Reviews"),
                              ),
                            )
                          : ReviewList(reviews: reviews),
                    ],
                  ),
                ),
              ),
              _buildBookNowButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhotoScroller() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.hostelImage.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                cacheManager: DefaultCacheManager(),
                key: UniqueKey(),
                imageUrl: widget.hostelImage[index],
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
          );
        },
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetail("Owner Name", widget.ownerName),
          buildDetail("Rent", "₹${widget.rent}/month"),
          buildDetail("Mess", widget.mess),
          const SizedBox(height: 20),
          const Text(
            "Select Room and Bed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...rooms.map((room) => _buildRoomCard(room)),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_comment, color: Colors.white),
            label: const Text("Add a Review",
                style: TextStyle(color: Colors.white)),
            onPressed: _openAddReviewModal,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Room ${room['roomNumber']}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(room['beds'].length, (index) {
                bool isAvailable = room['beds'][index];
                return GestureDetector(
                  onTap: isAvailable
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "You selected bed ${index + 1} in Room ${room['roomNumber']}",
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Implement booking functionality here
          },
          child: const Text(
            "Book Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => ChatPage(room: room)));
  }
}
