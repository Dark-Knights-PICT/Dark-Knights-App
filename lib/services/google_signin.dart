import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/models/admin_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class SignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithGoogleUser() async {
    late final bool isNewUser;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        storeUserDetails();
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((user) {
        LocalUser.uid = user['uid'];
        LocalUser.email = user['email'];
        LocalUser.displayName = user['displayName'];
        LocalUser.photoURL = user['photoURL'];
        LocalUser.isCA = user['isCA'];
        LocalUser.caId = user['caId'] ?? '';
      });
      return isNewUser;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> storeUserDetails() async {
    final CollectionReference usercollection =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String email = auth.currentUser!.email.toString();
    User? user = auth.currentUser;

    await usercollection.doc(uid).set({
      "displayName": user!.displayName,
      "phoneNumber": user.phoneNumber,
      "email": email,
      "photoURL": user.photoURL,
      "uid": user.uid,
      "lastMessageTime": Timestamp.now(),
      "isCA": false,
      "caId": null,
    }, SetOptions(merge: true));

    // TODO: Add Admin User to Database
    // final CollectionReference chatCollection = FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(uid)
    //     .collection('Chats');
    // chatCollection.add(
    //   {
    //     "displayName": AdminInfo.displayName,
    //     "phoneNumber": AdminInfo.phoneNumber,
    //     "email": AdminInfo.email,
    //     "photoURL": AdminInfo.photoURL,
    //     "uid": AdminInfo.uid,
    //     "createdAt": Timestamp.now(),
    //     "Message":
    //         "Hi there I am your CA, Welcome to this app! Feel free to ask any doubts here!",
    //   },
    // );
    return;
  }

  Future signInWithGoogleAdmin() async {
    late final bool isNewUser;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        storeAdminDetails();
      }

      log("Admin Test");

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((user) {
        AdminInfo.uid = user['uid'];
        AdminInfo.email = user['email'];
        AdminInfo.displayName = user['displayName'];
        AdminInfo.photoURL = user['photoURL'];
        AdminInfo.isCA = user['isCA'];
      });

      log("Hello");
      log(AdminInfo.uid!);
      return;
    } catch (e) {
      log(e.toString());
      return e;
    }
  }

  Future<void> storeAdminDetails() async {
    final CollectionReference usercollection =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String email = auth.currentUser!.email.toString();
    User? user = auth.currentUser;

    await usercollection.doc(uid).set({
      "displayName": user!.displayName,
      "phoneNumber": user.phoneNumber,
      "email": email,
      "photoURL": user.photoURL,
      "uid": user.uid,
      "lastMessageTime": Timestamp.now(),
      "isCA": true,
    }, SetOptions(merge: true));
  }
}
