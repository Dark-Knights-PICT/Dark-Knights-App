import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/models/select_client_details.dart';
import 'package:flutter/material.dart';

import '../../models/admin_info.dart';
import 'widgets/file_display_widget.dart';

class FileHomeAdmin extends StatefulWidget {
  const FileHomeAdmin({Key? key}) : super(key: key);

  @override
  State<FileHomeAdmin> createState() => _FileHomeAdminState();
}

class _FileHomeAdminState extends State<FileHomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010413),
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'Client Documents',
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
                          documentOfUID = chatTile['uid'];
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminUserFiles(
                              username: chatTile['displayName'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
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
                        trailing: const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 38,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 10.0,
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
