import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../project/bottombar.dart';

class SelectCA extends StatefulWidget {
  const SelectCA({Key? key}) : super(key: key);

  @override
  State<SelectCA> createState() => _SelectCAState();
}

class _SelectCAState extends State<SelectCA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'Select your CA',
          style: TextStyle(
              color: Color(0xff5ad0b5),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Lato'),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('isCA', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final users = snapshot.data.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userTile = users[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final currUUID = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currUUID)
                            .update({'caId': userTile['uid']});
                        LocalUser.caId = userTile['uid'];
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomBar(),
                          ),
                        );
                      },
                      child: ListTile(
                        // focusColor: Color(0xff010413),
                        // selectedTileColor: Color(0xfff403ffc).withOpacity(0.3),
                        leading: CircleAvatar(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userTile['photoURL']),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              userTile['displayName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ],
                        ),
                        subtitle: userTile['phoneNumber'] != null
                            ? Container(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  userTile['email'] +
                                      " " +
                                      userTile['phoneNumber'],
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
                                  userTile['email'],
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
