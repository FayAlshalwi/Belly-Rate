import 'package:belly_rate/ContactUs.dart';
import 'package:belly_rate/auth/our_user_model.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:belly_rate/auth/signup_page.dart';
import 'package:belly_rate/updateProfile.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class myProfile extends StatefulWidget {
  myProfile({Key? key}) : super(key: key);

  _myProfile createState() => _myProfile();
}

class _myProfile extends State<myProfile> {
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

      ourUser = OurUser(
        name: vari.data()!['name'],
        // first_name: vari.data()!['firstName'],
        picture: vari.data()!['picture'],
        phone_number: vari.data()!['phoneNumber'],
      );
      setState(() {});
    });

    // User? user =  FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final Color txt_color = Color(0xFF5a3769);
    final Color button_color = Color.fromARGB(255, 216, 107, 147);
    final double heightM = MediaQuery.of(context).size.height / 30;
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
        actions: [
          IconButton(
            padding: EdgeInsets.only(
              right: 15,
            ),
            onPressed: () async {
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  text: 'Are you sure you want to logout?',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'Cancel',
                  title: "Logout",
                  onCancelBtnTap: () {
                    Navigator.of(context).pop(true);
                  },
                  onConfirmBtnTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  });
            },
            icon: Icon(
              Icons.logout_outlined,
              color: const Color(0xFF5a3769),
              size: 30,
            ),
          )
        ],
      ),
      body: ourUser == null
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 35,
                  color: Color(0xFF5a3769),
                  secondRingColor: Colors.grey.shade700,
                  thirdRingColor: Color.fromARGB(255, 216, 107, 147)),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Spacer(),
                  SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: ourUser!.picture == null
                        ? Image.network(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                            fit: BoxFit.cover,
                            height: 150.0,
                            width: 150.0,
                          )
                        : Image.network(
                            "${ourUser!.picture}",
                            fit: BoxFit.cover,
                            height: 150.0,
                            width: 150.0,
                            // errorBuilder: ,
                          ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Text(
                      "${ourUser?.name}",
                      style: getMyTextStyle(
                          txt_color: txt_color, fontSize: heightM * 0.75),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${ourUser?.phone_number}",
                      style: getMyTextStyle(
                          txt_color: Colors.grey, fontSize: heightM * 0.6),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 12),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: heightM * 1.5,
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(5.0), //12
                          color: Colors
                              .transparent, //Colors.cyan.withOpacity(0.5),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: button_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            splashColor: button_color,
                            onPressed: () async {
                              /// UpdateProfile
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateProfile(ourUser: ourUser)))
                                  .then((value) async {
                                if (value) {
                                  var vari = await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(user!.uid)
                                      .get();
                                  // Map<String,dynamic> userData = vari as Map<String,dynamic>;
                                  print("currentUser: ${vari.data()}");

                                  ourUser = OurUser(
                                    name: vari.data()!['name'],
                                    // first_name: vari.data()!['firstName'],
                                    picture: vari.data()!['picture'],
                                    phone_number: vari.data()!['phoneNumber'],
                                  );
                                  setState(() {});
                                }
                              });
                            },
                            child: Text('Update Profile',
                                textAlign: TextAlign.center,
                                style: getMyTextStyle(
                                    txt_color: Colors.white,
                                    fontSize: heightM * 0.6)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1000,
                  ),

                  if (ourUser != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 200.0, top: 12),
                      child: Center(
                        child: Container(
                          width: 190,
                          height: heightM * 1.5,
                          child: Material(
                            borderRadius: BorderRadius.circular(55.0),
                            color: Colors.transparent,
                            child: FloatingActionButton.extended(
                              backgroundColor: Color.fromARGB(255, 92, 195, 95),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContactUs()));
                              },
                              icon: Icon(
                                Icons.contact_support_rounded,
                                size: 24.0,
                              ),
                              label: Text('Contact us',
                                  textAlign: TextAlign.center,
                                  style: getMyTextStyle(
                                      txt_color: Colors.white,
                                      fontSize: heightM * 0.6)),
                            ),
                          ),
                        ),
                      ),
                    ),

                  Spacer(),
                  Spacer(),
                  Spacer(),
                ],
              ),
            ),
    );
  }

  TextStyle getMyTextStyle({required Color txt_color, double fontSize = 22}) {
    return GoogleFonts.cairo(
        color: txt_color, fontSize: fontSize, fontWeight: FontWeight.bold);
  }
}
