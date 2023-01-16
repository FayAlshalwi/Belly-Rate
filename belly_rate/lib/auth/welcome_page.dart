import 'package:belly_rate/auth/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'our_user_model.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  User? user  ;
  OurUser? ourUser ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser! ;
    print("currentUser: ${user?.uid}");

    Future.delayed(Duration.zero).then((value) async {
      var vari =await FirebaseFirestore.instance.collection("Users").doc(user!.uid).get();
      // Map<String,dynamic> userData = vari as Map<String,dynamic>;
      print("currentUser: ${vari.data()}");

      ourUser = OurUser(
        first_name:  vari.data()!['firstName'],
        last_name: vari.data()!['lastName'],
        phone_number: vari.data()!['phoneNumber'],
        picture : vari.data()!['picture'],
      );
      setState(() {});
      });

    // User? user =  FirebaseAuth.instance.currentUser;


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome "),
            Text("First Name :  ${ourUser?.first_name}"),
            Text("Last Name :  ${ourUser?.last_name}"),
            Text("Mobile Number :  ${ourUser?.phone_number}"),
            MaterialButton(
                color: Colors.red,
                child: Text("Sign-Out" , style: TextStyle(color: Colors.white)),
                onPressed: () async {
              await FirebaseAuth.instance.signOut();


              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignIn()), (Route<dynamic> route) => false);

            })
          ],
        ),
      ),
    );
  }
}
