import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

UploadTask? task;
File? file;

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException {
      return null;
    }
  }
}

Future selectFile() async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

  if (result == null) return;
  final path = result.files.single.path!;

  file = File(path);
}

Future uploadFile(context, String id, {String type = "UserDocument"}) async {
  if (file == null) return;

  final fileName = basename(file!.path);
  final destination = 'Documents/$id/User/$fileName';

  task = FirebaseApi.uploadFile(destination, file!);

  if (task == null) return;

  final snapshot = await task!.whenComplete(() {});
  final urlDownload = await snapshot.ref.getDownloadURL();

  await FirebaseFirestore.instance
      .collection("Users")
      .doc(id)
      .collection("Documents")
      .add({
    'Name': fileName,
    'Type': type,
    'URL': urlDownload,
    'createdAt': Timestamp.now(),
  });

  return AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    title: 'Succes',
    desc: 'File Upload Successfully!',
    btnOkIcon: Icons.check_circle,
    btnOkOnPress: () {},
  ).show();
}
