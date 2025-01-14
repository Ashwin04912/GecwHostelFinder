import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gecw_lakx/application/hostel_process/common_hostel_process/common_hostel_process_bloc.dart';
import 'package:gecw_lakx/presentation/hostel_details/widgets/build_review_widget.dart';

class ScreenAllReviewsOfHostelScreen extends StatefulWidget {
  final String hostelId;
  const ScreenAllReviewsOfHostelScreen({super.key, required this.hostelId});

  @override
  State<ScreenAllReviewsOfHostelScreen> createState() =>
      _ScreenAllReviewsOfHostelScreenState();
}

class _ScreenAllReviewsOfHostelScreenState
    extends State<ScreenAllReviewsOfHostelScreen> {
  List<Map<String, String>> reviews = [];

  @override
  void initState() {
    context.read<CommonHostelProcessBloc>().add(
        CommonHostelProcessEvent.getAllratingsAndReview(
            hostelId: widget.hostelId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Reviews"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E2C), Color(0xFF121212)],
          ),
        ),
        child: BlocConsumer<CommonHostelProcessBloc, CommonHostelProcessState>(
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
            if (reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.comment,
                      size: 80,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Reviews Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "It seems like there are no reviews for this hostel yet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "User Reviews",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ReviewList(
                          reviews: [review], // Pass a single review
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
