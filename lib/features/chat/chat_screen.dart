import 'package:flutter/material.dart';

import 'widgets/messages.dart';
import 'widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String uid;
  const ChatScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: const Color(0xff010413),
        body: Column(
          children: [
            Expanded(
              child: Messages(uid: uid),
            ),
            const NewMessage(),
          ],
        ),
      ),
    );
  }
}
