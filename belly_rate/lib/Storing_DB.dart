import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../firebase_options.dart';

addData(String ID, File img, File img2, File img3, File img4, String name,
    String cat, String des, String loc, String phone, String price) async {
  print("1");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("1");

  String fileName = basename(img.path);
  print("1");

  String fileName2 = basename(img2.path);
  String fileName3 = basename(img3.path);
  String fileName4 = basename(img4.path);

  //uploadImageToFirebase
  FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
  print("1");

  Reference ref = firebaseStorageRef.ref().child('images/$fileName');
  print("1");

  Reference ref2 = firebaseStorageRef.ref().child('images/$fileName2');
  Reference ref3 = firebaseStorageRef.ref().child('images/$fileName3');
  Reference ref4 = firebaseStorageRef.ref().child('images/$fileName4');

  UploadTask uploadTask = ref.putFile(img);
  print("12");

  final TaskSnapshot downloadUrl = (await uploadTask);
  print("1");

  final String url = await downloadUrl.ref.getDownloadURL();

  UploadTask uploadTask2 = ref2.putFile(img2);
  final TaskSnapshot downloadUrl2 = (await uploadTask2);
  final String url2 = await downloadUrl2.ref.getDownloadURL();

  UploadTask uploadTask3 = ref3.putFile(img3);
  final TaskSnapshot downloadUrl3 = (await uploadTask3);
  final String url3 = await downloadUrl3.ref.getDownloadURL();

  UploadTask uploadTask4 = ref4.putFile(img4);
  final TaskSnapshot downloadUrl4 = (await uploadTask4);
  final String url4 = await downloadUrl4.ref.getDownloadURL();

  CollectionReference PostRec =
      await FirebaseFirestore.instance.collection('Restaurants');
  PostRec.add({
    'ID': ID,
    'name': name,
    'description': des,
    'location': loc,
    'phoneNumber': phone,
    'priceAvg': price,
    'categorey': cat,
    "photos": [url, url2, url3, url4],
  });
}

@override
void initState() {
  initState();
}
