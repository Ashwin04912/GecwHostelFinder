// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

// // class ChatPage extends StatelessWidget {
// //   final types.Room room;

// //   const ChatPage({
// //     Key? key,
// //     required this.room,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(room.name ?? 'Chat'),
// //         backgroundColor: Colors.black,
// //       ),
// //       backgroundColor: Colors.black,
// //       body: StreamBuilder<List<types.Message>>(
// //         initialData: const [],
// //         stream: FirebaseChatCore.instance.messages(room),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator(color: Colors.white));
// //           }

// //           if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return const Center(
// //               child: Text(
// //                 'No messages yet.',
// //                 style: TextStyle(color: Colors.white70),
// //               ),
// //             );
// //           }

// //           final messages = snapshot.data!;
// //           return Chat(
// //             messages: messages,
// //             onSendPressed: _handleSendPressed,
// //             user: types.User(id: FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
// //             showUserAvatars: true, // Displays user avatars
// //             showUserNames: true,  // Displays user names
// //             theme: const DarkChatTheme(),
// //           );
// //         },
// //       ),
// //     );
// //   }

//   void _handleSendPressed(types.PartialText message) {
//     FirebaseChatCore.instance.sendMessage(
//       types.PartialText(
//         text: message.text,
//       ),
//       room.id,
//     );
//   }
// }




class ChatPage extends StatefulWidget {
  final types.Room room;

  const ChatPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final _user = types.User(id: FirebaseChatCore.instance.firebaseUser?.uid ?? '');

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Subscribe to the messages stream
    FirebaseChatCore.instance.messages(widget.room).listen((messages) {
      setState(() {
        _messages
          ..clear()
          ..addAll(messages);
        // Ensure messages are sorted by creation time (newest first)
        _messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: const Color(0xff1f1c38),
          foregroundColor: Colors.white,
          title: Text(widget.room.name.toString()),
        ),
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          theme: const DarkChatTheme(),
        ),
      );

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      types.PartialText(
        text: message.text,
      ),
      widget.room.id,
    );
  }
}

