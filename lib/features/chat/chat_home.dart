import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/models/select_client_details.dart';
import 'package:darkknightspict/features/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../models/admin_info.dart';
import '../../models/user.dart';
import 'chat_screen.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010413),
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'Chats',
          style: TextStyle(
              color: Color(0xff5ad0b5),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Lato'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              LocalUser.uid = null;
              AdminInfo.uid = null;
              print("Hello");
              log('Logout button pressed');
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false);
            },
            icon: const Icon(
              Icons.logout,
              color: Color(0xff5ad0b5),
            ),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('caId', isEqualTo: AdminInfo.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chats = snapshot.data.docs;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                final chatTile = chats[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          chatwithUID = chatTile['uid'];
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              uid: chatwithUID!,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        // focusColor: Color(0xff010413),
                        // selectedTileColor: Color(0xfff403ffc).withOpacity(0.3),
                        leading: CircleAvatar(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(chatTile['photoURL']),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              chatTile['displayName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            Text(
                              DateFormat.jm()
                                  .format(chatTile['lastMessageTime'].toDate())
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        subtitle: chatTile['phoneNumber'] != null
                            ? Container(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  chatTile['email'] +
                                      " " +
                                      chatTile['phoneNumber'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  chatTile['email'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const Divider(
                      height: 10.0,
                      //color:Color(0xff5858f3),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
