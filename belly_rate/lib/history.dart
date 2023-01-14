import 'dart:convert';
import 'package:belly_rate/auth/our_user_model.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:belly_rate/auth/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class history extends StatefulWidget {
  history({Key? key}) : super(key: key);

  _history createState() => _history();
}

class _history extends State<history> {
  User? user;
  OurUser? ourUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    print("currentUser: ${user?.uid}");

    Future.delayed(Duration.zero).then((value) async {
      var vari = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .get();
      // Map<String,dynamic> userData = vari as Map<String,dynamic>;
      print("currentUser: ${vari.data()}");

      // ourUser = OurUser(
      //   first_name: vari.data()!['firstName'],
      //   last_name: vari.data()!['lastName'],
      //   phone_number: vari.data()!['phoneNumber'],
      // );
      setState(() {});
    });

    // User? user =  FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 22,
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome "),
            Text("Name :  ${ourUser?.first_name}"),
            Text("Mobile Number :  ${ourUser?.phone_number}"),
            ElevatedButton(
                onPressed: () async {
                  print("here1");

                  final uri = Uri.parse('https://gpapi.herokuapp.com/ratings');
                  print("here2");

                  final response = await get(uri);
                  print("here3");
                  print(response.body);
                  print("here");

                  final decoded =
                      json.decode(response.body) as Map<String, dynamic>;
                  print("here4");

                  print(decoded['recommeneded']);
                },
                child: Text("print")),
            ElevatedButton(
                onPressed: () async {
                  final url = 'http://127.0.0.1:5000/';
                  final uri = Uri.parse('https://gpapi.herokuapp.com/ratings');

                  final response = await post(uri,
                      body: json.encode({
                        'rating': ["U22", "ty", 8, 5, 9]
                      }));
                },
                child: Text("Add Rate"))
          ],
        ),
      ),
    );
  }
}
