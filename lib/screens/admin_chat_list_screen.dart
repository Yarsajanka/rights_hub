import 'package:flutter/material.dart';
import 'admin_chat_screen.dart';

class AdminChatListScreen extends StatelessWidget {
  final List<Map<String, String>> sampleChats = [
    {'userId': '1', 'userName': 'John Doe'},
    {'userId': '2', 'userName': 'Alice Smith'},
    {'userId': '3', 'userName': 'Michael Johnson'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Chats'),
      ),
      body: ListView.builder(
        itemCount: sampleChats.length,
        itemBuilder: (context, index) {
          final chat = sampleChats[index];
          return ListTile(
            title: Text(chat['userName'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminChatScreen(
                    userId: chat['userId'] ?? '',
                    userName: chat['userName'] ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
