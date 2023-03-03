import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String uid;
  const Messages({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        // final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) {
            bool isMe = false;
            if (LocalUser.uid != null) {
              if (chatDocs[index]['uid'] == uid) {
                isMe = true;
              }
            } else {
              if (chatDocs[index]['uid'] != uid) {
                isMe = true;
              }
            }
            return MessageBubble(
              chatDocs[index]['Message'],
              chatDocs[index]['displayName'],
              chatDocs[index]['photoURL'],
              isMe,
            );
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
