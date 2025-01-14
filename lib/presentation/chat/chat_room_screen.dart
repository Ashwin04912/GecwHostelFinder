import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat_page.dart'; // Ensure you have the ChatPage imported

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  // Handle the user tap to create a chat room and navigate to the chat page
  void _handlePressed(types.Room room, BuildContext context) async {
    // Navigate to the ChatPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        title: const Text('Messages'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(), // Use `rooms()` stream for chat rooms
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No chat rooms available.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final rooms = snapshot.data!;

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[700],
                  child: Text(
                    room.name?.substring(0, 1).toUpperCase() ?? '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  room.name ?? 'Unknown Room',
                  style: const TextStyle(color: Colors.white),
                ),
                // Optionally, you can show more details like the last message here
                onTap: () => _handlePressed(room, context), // Pass room instead of user
              );
            },
          );
        },
      ),
    );
  }
}
