import 'package:flutter/material.dart';
import 'package:gecw_lakx/presentation/hostel_details/all_reviews_screen.dart';

class HostelDetailsOwnerAppScreen extends StatelessWidget {
  final String hostelId;
  final List<String> hostelImages;
  const HostelDetailsOwnerAppScreen({
    super.key,
    required this.hostelId,
    required this.hostelImages
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const Text("Hostel Details"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              // Handle chat icon press
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E2C), Color(0xFF121212)], // Dark gradient
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // Horizontal Image Scroller
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hostelImages.length, // Replace with actual image count
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(hostelImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Hostel Details
            const Text(
              "Hostel Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Location: 123 Main Street, City Name",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Text(
              "Rooms Available: 20",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Text(
              "Facilities: Wi-Fi, Gym, Laundry, Parking",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle edit details
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Edit Details",style: TextStyle(color: Colors.white),),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenAllReviewsOfHostelScreen(hostelId: hostelId,)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("See All Reviews"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Delete Button
            ElevatedButton(
              onPressed: () {
                _showDeleteDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Delete Hostel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Additional Info Section
            const Text(
              "Additional Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Nearby Places: Grocery Store, Park, Shopping Mall",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Text(
              "Monthly Rent: \$500 per room",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle chat
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  // Show confirmation dialog before deletion
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Hostel"),
          content: const Text("Are you sure you want to delete this hostel? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle the delete action
                Navigator.of(context).pop(); // Close the dialog
                // Add your delete hostel function here
                _deleteHostel();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Handle deletion of the hostel (this is a placeholder for the actual delete logic)
  void _deleteHostel() {
    // Implement your delete functionality here (e.g., call a delete API, remove from Firebase, etc.)
    print("Hostel with ID $hostelId has been deleted.");
  }
}
