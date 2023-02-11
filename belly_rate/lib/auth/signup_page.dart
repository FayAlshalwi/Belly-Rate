import 'dart:convert';

import 'package:belly_rate/HomePage.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_btn/loading_btn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String phoneNumber = "";
  late PhoneNumber phonenum;
  TextEditingController phone = TextEditingController();
  TextEditingController first_name = TextEditingController();
  bool _onEditing = true;
  String? _code;
  late QuerySnapshot<Map<String, dynamic>> res;
  List numbers = [];
  final _formPass = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();

    getUsers();
  }

  getUsers() async {
    await new Future.delayed(const Duration(seconds: 2));
    res = await FirebaseFirestore.instance.collection('Users').get();
    print(res.docs.length);
    for (int i = 0; i < res.docs.length; i++) {
      setState(() {
        numbers.add(res.docs[i]['phoneNumber']);
      });
      print(numbers[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color txt_color = Color(0xFF5a3769);
    Color button_color = Color.fromARGB(255, 216, 107, 147);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightM * 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 8.0, bottom: 0.0),
              child: Text(
                "Sign Up",
                style: ourTextStyle(txt_size: heightM, txt_color: txt_color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 0.0, bottom: 8.0),
              child: Text(
                "Welcome! Glad you joined our app",
                style: ourTextStyle(
                    txt_size: heightM * 0.7, txt_color: Colors.black45),
              ),
            ),
            Center(
              child: Image.network(
                  "http://www.highvincent.com/HighVin/ContentNew/images/login.png",
                  height: heightM * 10.0,
                  fit: BoxFit.fill),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Name",
                  style: ourTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.6),
                ),
              ),
            ),
            Form(
                key: _formPass,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  width: 380,
                  height: 60,
                  margin: EdgeInsets.fromLTRB(23, 02, 10, 10),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withOpacity(0.13)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffeeeeee),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      Stack(alignment: AlignmentDirectional.center, children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _formPass.currentState?.validate();
                        print(first_name.text);
                      },
                      validator: (value) {
                        final regExp = RegExp(r'^[ a-zA-Z]+$');
                        String text = first_name.text;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else if (!regExp.hasMatch(text.trim())) {
                          return 'You cannot enter special characters and numbers';
                        } else if (value.length <= 2) {
                          return "Please enter at least 3 characters";
                        }
                      },

                      maxLength: 15,
                      controller: first_name,
                      cursorColor: Colors.black,
                      // keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                        hintText: "Your Name",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(158, 158, 158, 1),
                            fontSize: 16),
                      ),
                    ),
                  ]),
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Phone Number",
                  style: ourTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.6),
                ),
              ),
            ),
            Form(
                key: formKey,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  width: 380,
                  height: 60,
                  margin: EdgeInsets.fromLTRB(23, 02, 10, 10),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withOpacity(0.13)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffeeeeee),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      InternationalPhoneNumberInput(
                        initialValue:
                            PhoneNumber(isoCode: 'SA', dialCode: '+966'),
                        onInputChanged: (PhoneNumber number) {
                          formKey.currentState?.validate();
                          setState(() {
                            phonenum = number;

                            phoneNumber = number.phoneNumber!;
                            print("phoneNumber");
                            print(phoneNumber);
                          });

                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty ||
                              value == null ||
                              value.trim() == '') {
                            return 'Please enter your phone number';
                          } else if (value.length > 11 || value.length < 11) {
                            return 'Please enter 9 numbers';
                          } else if (true) {
                            for (int i = 0; i < numbers.length; i++) {
                              print(numbers[i]);
                              if (numbers[i] == phoneNumber) {
                                return 'You already have an account, please sign in';
                              }
                            }
                          }
                        },
                        selectorConfig: SelectorConfig(
                          useEmoji: true,
                          selectorType: PhoneInputSelectorType.DIALOG,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        textFieldController: phone,
                        formatInput: true,
                        maxLength: 11,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        cursorColor: Colors.black,
                        inputDecoration: InputDecoration(
                          errorStyle: TextStyle(height: 0),
                          contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                          border: InputBorder.none,
                          hintText: '5XXXXXXXX',
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(158, 158, 158, 1),
                              fontSize: 16),
                        ),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                      ),
                      Positioned(
                        left: 90,
                        top: 8,
                        bottom: 8,
                        child: Container(
                          height: 40,
                          width: 1,
                          color: Colors.black.withOpacity(0.13),
                        ),
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: heightM * 0.5,
            ),
            Center(
              child: Container(
                child: LoadingBtn(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: heightM * 1.5,
                  elevation: 10.0,
                  color: button_color,
                  borderRadius: 10,
                  animate: true,
                  //color: Colors.green,
                  loader: Container(
                    padding: const EdgeInsets.all(10),
                    width: 40,
                    height: 40,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  child: Text('Sign Up',
                      textAlign: TextAlign.center,
                      style: ourTextStyle(
                          txt_color: Colors.white, txt_size: heightM * 0.6)),

                  onTap: (startLoading, stopLoading, btnState) async {
                    if (btnState == ButtonState.idle) {
                      formKey.currentState?.save();
                      _formPass.currentState?.save();
                      if (formKey.currentState!.validate() &&
                          _formPass.currentState!.validate()) {
                        startLoading();

                        if (phone.text.isNotEmpty) {
                          print("here the submitted phone");
                          print(phone.text);

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {
                              stopLoading();

                              print("verificationCompleted: ${credential}");
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              if (e.code == 'invalid-phone-number') {
                                CoolAlert.show(
                                  context: context,
                                  title: "Invalid phone number",
                                  type: CoolAlertType.error,
                                  text:
                                      "The provided phone number is not valid",
                                  confirmBtnColor: button_color,
                                );
                                print(
                                    'The provided phone number is not valid.');
                                stopLoading();
                              }
                              print("verificationFailed: ${e}");
                            },
                            codeSent:
                                (String verificationId, int? resendToken) {
                              stopLoading();

                              openSheet(context, heightM, button_color,
                                  txt_color, verificationId);
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              print("codeSent: ${verificationId}");
                            },
                          );
                        }
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: heightM * 0.5,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Have an account? ",
                      style: ourTextStyle(
                          txt_color: txt_color, txt_size: heightM * 0.55),
                    ),
                    TextSpan(
                      text: ' Sign In',
                      style: ourTextStyle(
                          txt_color: button_color, txt_size: heightM * 0.55),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Sign In");
                          // SignUpPage
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                          // Long Pressed.
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void openSheet(
      BuildContext context, heightM, button_color, txt_color, verificationId) {
    showModalBottomSheet(
        context: context,
        elevation: 20,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'OTP Verification',
                        style: ourTextStyle(
                            txt_color: txt_color, txt_size: heightM * 0.7),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        ' Enter the OTP you received to ${phoneNumber}',
                        style: ourTextStyle(
                            txt_color: txt_color, txt_size: heightM * 0.5),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: VerificationCode(
                    digitsOnly: true,
                    textStyle: ourTextStyle(
                        txt_color: txt_color, txt_size: heightM * 0.5),
                    keyboardType: TextInputType.number,
                    fullBorder: true,
                    underlineColor: button_color,
                    length: 6,
                    cursorColor: txt_color,
                    onCompleted: (String value) {
                      setState(() {
                        _code = value;
                      });
                    },
                    onEditing: (bool value) {
                      setState(() {
                        _onEditing = value;
                      });
                      if (!_onEditing) FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      // height: heightM * 1.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          // elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          // color: Color.fromARGB(0, 244, 67, 54),
                          child: MaterialButton(
                            height: heightM * 1.2,
                            minWidth: MediaQuery.of(context).size.width * 0.4,
                            color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Back',
                                textAlign: TextAlign.center,
                                style: ourTextStyle(
                                    txt_color: Colors.white,
                                    txt_size: heightM * 0.6)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Material(
                          // elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          color: Colors
                              .transparent, //Colors.cyan.withOpacity(0.5),
                          child: LoadingBtn(
                            loader: Container(
                              padding: const EdgeInsets.all(10),
                              child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: heightM * 1.2,
                            color: button_color,
                            borderRadius: 10,
                            onTap: (startLoading, stopLoading, btnState) async {
                              if (btnState == ButtonState.idle) {
                                startLoading();
                                try {
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: _code!);

                                  print("user  credential!!! ");
                                  print("user  !!! ");

                                  print(credential);

                                  print("hiiiiiii");
                                  final userCredential = await FirebaseAuth
                                      .instance
                                      .signInWithCredential(credential);

                                  String firebaseToken =
                                      await userCredential.user!.getIdToken();
                                  print("firebaseToken");
                                  print(firebaseToken);

                                  String userUid = userCredential.user!.uid;
                                  print("user id userUid!!! @@@@");
                                  print(userUid);
                                  print("firstName");
                                  print(first_name.text);
                                  print("here1");
                                  final uri = Uri.parse(
                                      'https://bellyrate-urhmg.ondigitalocean.app/ratings');
                                  print("here2");
                                  final response = await get(
                                    uri,
                                    headers: <String, String>{
                                      'usrID': FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString(),
                                    },
                                  );
                                  print("here3");
                                  print(response.body);
                                  print("here");
                                  var responseData = json.decode(response.body);
                                  print(responseData[0].toString());
                                  print(responseData[1].toString());
                                  print(responseData[2].toString());
                                  print("here4");
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(userUid)
                                      .set({
                                    'name': first_name.text,
                                    'phoneNumber': phoneNumber,
                                    'uid': userUid,
                                    'picture':
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                    'rest': [
                                      responseData[0].toString(),
                                      responseData[1].toString(),
                                      responseData[2].toString(),
                                    ],
                                  });
                                  print("user added");
                                  FirebaseFirestore.instance
                                      .collection('Recommendation')
                                      .doc()
                                      .set({
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'RestaurantId': responseData[0].toString(),
                                    'Notified': false,
                                    'Notified_location': false,
                                    "Date_Of_Recommendation":
                                        FieldValue.serverTimestamp(),
                                  });

                                  print("Recommendation 1 added");

                                  FirebaseFirestore.instance
                                      .collection('Recommendation')
                                      .doc()
                                      .set({
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'RestaurantId': responseData[1].toString(),
                                    'Notified': false,
                                    'Notified_location': false,
                                    "Date_Of_Recommendation":
                                        FieldValue.serverTimestamp(),
                                  });

                                  print("Recommendation 2 added");

                                  FirebaseFirestore.instance
                                      .collection('Recommendation')
                                      .doc()
                                      .set({
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'RestaurantId': responseData[2].toString(),
                                    'Notified': false,
                                    'Notified_location': false,
                                    "Date_Of_Recommendation":
                                        FieldValue.serverTimestamp(),
                                  });

                                  print("Recommendation 3 added");

                                  FirebaseFirestore.instance
                                      .collection('History')
                                      .doc()
                                      .set({
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'RestaurantId': responseData[0].toString(),
                                    'Notified': false,
                                    'Notified_location': false,
                                    "Date_Of_Recommendation":
                                        FieldValue.serverTimestamp(),
                                  });
                                  print("History 1 added");
                                  FirebaseFirestore.instance
                                      .collection('History')
                                      .doc()
                                      .set({
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'RestaurantId': responseData[1].toString(),
                                    'Notified': false,
                                    'Notified_location': false,
                                    "Date_Of_Recommendation":
                                        FieldValue.serverTimestamp(),
                                  });
                                  print("History 2 added");
                                  FirebaseFirestore.instance
                                      .collection('History')
                                      .doc()
                                      .set({
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'RestaurantId': responseData[2].toString(),
                                    'Notified': false,
                                    'Notified_location': false,
                                    "Date_Of_Recommendation":
                                        FieldValue.serverTimestamp(),
                                  });
                                  print("History 3 added");
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: 'Sign Up completed successfully!',
                                  );
                                  stopLoading();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => SignIn()),
                                      (Route<dynamic> route) => false);
                                } on FirebaseAuthException catch (error) {
                                  stopLoading();
                                  Navigator.of(context).pop();
                                  String Error = "";
                                  print("e ${error}");

                                  if (error
                                      .toString()
                                      .contains("does not exist")) {
                                    CoolAlert.show(
                                      context: context,
                                      title: "No user correspond",
                                      type: CoolAlertType.error,
                                      text:
                                          "User Not Exist! , Please Go to Sign Up Page",
                                      confirmBtnColor: button_color,
                                    );
                                  } else if (error.toString().contains(
                                      "The sms verification code used to create the phone auth credential is invalid")) {
                                    CoolAlert.show(
                                      context: context,
                                      title: "Wrong OTP",
                                      type: CoolAlertType.error,
                                      text: "Invalid verification code",
                                      confirmBtnColor: button_color,
                                    );
                                    Error = "Code Error !";
                                  } else if (error.code ==
                                      'invalid-verification-code') {
                                    CoolAlert.show(
                                      context: context,
                                      title: "Wrong OTP",
                                      type: CoolAlertType.error,
                                      text: "Invalid verification code",
                                      confirmBtnColor: button_color,
                                    );
                                    Error = "Wrong OTP entered";
                                  }
                                  stopLoading();
                                  print("ddd_222 ${error}");

                                  // if (e.code == 'invalid-verification-code') {
                                  //   CoolAlert.show(
                                  //     context: context,
                                  //     title: "",
                                  //     type: CoolAlertType.error,
                                  //     text: "Error",
                                  //     confirmBtnColor: button_color,
                                  //   );
                                  // }
                                }
                              }
                              else{
                                 stopLoading();
                                CoolAlert.show(
                                  context: context,
                                  title: "Empty OTP",
                                  type: CoolAlertType.error,
                                  text: "Please, Enter OTP sent to your phone",
                                  confirmBtnColor: button_color,
                                );
                              }
                            },
                            child: Text('Sign Up',
                                textAlign: TextAlign.center,
                                style: ourTextStyle(
                                    txt_color: Colors.white,
                                    txt_size: heightM * 0.6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
              ],
            ),
          );
        });
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
  }
}
