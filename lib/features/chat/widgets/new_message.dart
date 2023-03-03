import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/admin_info.dart';
import '../../../models/select_client_details.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMesaage = "";

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Chats')
        .add({
      "displayName": user.displayName,
      "phoneNumber": user.phoneNumber,
      "email": user.email,
      "photoURL": user.photoURL,
      "uid": user.uid,
      "createdAt": Timestamp.now(),
      "Message": _enteredMesaage,
    });
    FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
      "lastMessageTime": Timestamp.now(),
    });
    _controller.clear();
  }

  void _sendMessageAdmin() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(chatwithUID)
        .collection('Chats')
        .add({
      "displayName": AdminInfo.displayName,
      "phoneNumber": AdminInfo.phoneNumber,
      "email": AdminInfo.email,
      "photoURL": AdminInfo.photoURL,
      "uid": AdminInfo.uid,
      "createdAt": Timestamp.now(),
      "Message": _enteredMesaage,
    });
    FirebaseFirestore.instance.collection('Users').doc(chatwithUID).update({
      "lastMessageTime": Timestamp.now(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          //Textfield takes as much space as available therefore wrap it into expanded widget
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all()),
              child: TextField(
                textInputAction: TextInputAction.send,
                controller: _controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Send a message',
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                    )),
                onEditingComplete: () {},
                onChanged: (val) {
                  setState(() {
                    _enteredMesaage = val;
                  });
                },
              ),
            ),
          ),
          IconButton(
            onPressed: _enteredMesaage.trim().isEmpty
                ? null
                : AdminInfo.uid != null
                    ? _sendMessageAdmin
                    : _sendMessage,
            icon: const Icon(
              Icons.send,
              // color: Colors.black,
              color: Color(0xff8564d6),
            ),
          )
        ],
      ),
    );
  }
}
