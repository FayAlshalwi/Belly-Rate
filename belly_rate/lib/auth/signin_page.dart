import 'package:belly_rate/HomePage.dart';
import 'package:belly_rate/auth/signup_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:animate_do/animate_do.dart';
import 'package:loading_btn/loading_btn.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  late PhoneNumber phonenum;
  bool _onEditing = true;
  String? _code;
  String phoneNumber = "";

  TextEditingController phone = TextEditingController();
  late QuerySnapshot<Map<String, dynamic>> res;
  List numbers = [];

  void initState() {
    super.initState();

    getUsers();
  }

  getUsers() async {
    // await new Future.delayed(const Duration(seconds: 2));
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
          child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightM * 3,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 8.0, bottom: 0.0),
              child: Text(
                "Sign In",
                style: ourTextStyle(txt_size: heightM, txt_color: txt_color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 0.0, bottom: 8.0),
              child: Text(
                "Hi there! Nice to see you again",
                style: ourTextStyle(
                    txt_size: heightM * 0.7, txt_color: Colors.black45),
              ),
            ),
            Center(
              child: Image.network(
                  "https://my.messa.online/images_all/2022-login.gif",
                  height: heightM * 8.50,
                  fit: BoxFit.fill),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Phone Number",
                  style: ourTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.6),
                ),
              ),
            ),
            Container(
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
                    initialValue: PhoneNumber(isoCode: 'SA', dialCode: '+966'),
                    onInputChanged: (PhoneNumber number) {
                      phonenum = number;
                      print("phonenum");
                      print(phonenum);
                      phoneNumber = number.phoneNumber!;
                      print("phoneNumber");
                      print(phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    validator: (value) {
                      bool x = false;

                      if (value!.isEmpty ||
                          value == null ||
                          value.trim() == '') {
                        return 'Please enter your phone number';
                      }
                      // else if (value[0] != 5)
                      //   return 'Saudi numbers starts with 5 ';

                      else if (value.length > 11 || value.length < 11) {
                        return 'Please enter 9 numbers';
                      } else if (true) {
                        bool flag = false;
                        for (int i = 0; i < numbers.length; i++) {
                          print(numbers[i]);
                          if (numbers[i] == phoneNumber) {
                            flag = true;
                          }
                        }
                        if (flag == false)
                          return 'You don\'t have an account, please sign up';
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
                      hintText: '5X XXX XXXX',
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
            ),
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
                  child: Text('Sign In',
                      textAlign: TextAlign.center,
                      style: ourTextStyle(
                          txt_color: Colors.white, txt_size: heightM * 0.6)),

                  onTap: (startLoading, stopLoading, btnState) async {
                    if (btnState == ButtonState.idle) {
                      formKey.currentState?.save();
                      if (formKey.currentState!.validate()) {
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
                // child: Material(
                //   elevation: 10.0,
                //   borderRadius: BorderRadius.circular(10.0), //12
                //   color: Colors.transparent, //Colors.cyan.withOpacity(0.5),
                //   child: MaterialButton(
                //     minWidth: MediaQuery.of(context).size.width,
                //     color: button_color,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.0)),
                //     splashColor: button_color,
                //     onPressed: () async {
                //       print('rrrrr');
                //       formKey.currentState?.save();
                //       print('rrrrr');

                //       if (formKey.currentState!.validate()) {
                //         if (phone.text.isNotEmpty) {
                //           // if (formKey.currentState!.validate()) {
                //           CoolAlert.show(
                //             context: context,
                //             type: CoolAlertType.loading,
                //             text: "Loading",
                //           );
                //           print("here the submitted phone");
                //           print(phone.text);

                //           await FirebaseAuth.instance.verifyPhoneNumber(
                //             phoneNumber: phoneNumber,
                //             verificationCompleted:
                //                 (PhoneAuthCredential credential) {
                //               print("verificationCompleted: ${credential}");
                //             },
                //             verificationFailed: (FirebaseAuthException e) {
                //               if (e.code == 'invalid-phone-number') {
                //                 CoolAlert.show(
                //                   context: context,
                //                   title: "Invalid phone number",
                //                   type: CoolAlertType.error,
                //                   text:
                //                       "The provided phone number is not valid",
                //                   confirmBtnColor: button_color,
                //                 );
                //                 print(
                //                     'The provided phone number is not valid.');
                //               }
                //               print("verificationFailed: ${e}");
                //             },
                //             codeSent:
                //                 (String verificationId, int? resendToken) {
                //               openSheet(context, heightM, button_color,
                //                   txt_color, verificationId);
                //             },
                //             codeAutoRetrievalTimeout: (String verificationId) {
                //               print("codeSent: ${verificationId}");
                //             },
                //           );
                //           // }
                //         }
                //       }
                //     },
                //     child: Text('Sign In',
                //         textAlign: TextAlign.center,
                //         style: ourTextStyle(
                //             txt_color: Colors.white, txt_size: heightM * 0.6)),
                //   ),
                // ),
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
                      text: "Doesn't have an account? ",
                      style: ourTextStyle(
                          txt_color: txt_color, txt_size: heightM * 0.55),
                    ),
                    TextSpan(
                      text: ' Sign Up',
                      style: ourTextStyle(
                          txt_color: button_color, txt_size: heightM * 0.55),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Sign Up");
                          // SignUpPage
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                          // Long Pressed.
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
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
                    clearAll: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'clear all'.toUpperCase(),
                        style: ourTextStyle(
                            txt_color: txt_color, txt_size: heightM * 0.5),
                      ),
                    ),
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
                      height: heightM * 1.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          // color: Color.fromARGB(0, 244, 67, 54),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
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
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          color: Colors
                              .transparent, //Colors.cyan.withOpacity(0.5),
                          child: LoadingBtn(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: heightM * 1.9,
                            color: button_color,
                            borderRadius: 10,
                            loader: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            onTap: (startLoading, stopLoading, btnState) async {
                              if (btnState == ButtonState.idle) {
                                startLoading();
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: _code!);
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                } on FirebaseAuthException catch (error) {
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
                                if (FirebaseAuth.instance.currentUser != null) {
                                  stopLoading();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (Route<dynamic> route) => false);
                                }
                                stopLoading();
                              }
                            },
                            child: Text('Sign In',
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
