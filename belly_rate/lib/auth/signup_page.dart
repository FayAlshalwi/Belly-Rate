import 'package:belly_rate/auth/signin_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String phoneNumber = "";

  TextEditingController phone = TextEditingController();
  TextEditingController first_name = TextEditingController();
  bool _onEditing = true;
  String? _code;
  final formKey = GlobalKey<FormState>();

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
                  height: heightM * 8.0,
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

            Container(
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
              child: Stack(alignment: AlignmentDirectional.center, children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    formKey.currentState?.validate();
                  },
                  validator: (value) {
                    final regExp = RegExp(r'^[a-zA-Z]+$');
                    String text = first_name.text;
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!regExp.hasMatch(text.trim())) {
                      return 'You cannot enter special characters !@#\%^&*()';
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
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
            // Center(child: first_name_text(txt_color, heightM)),
            // Center(child: last_name_text(txt_color, heightM)),
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
                      formKey.currentState?.validate();
                      setState(() {
                        phoneNumber = number.phoneNumber!;
                      });
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // else if (value[0] != 5)
                      //   return 'Saudi numbers starts with 5 ';
                      else if (value.length > 9 || value.length < 9) {
                        return 'Please enter 9 numbers';
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
                    // formatInput: true,
                    maxLength: 9,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    cursorColor: Colors.black,
                    inputDecoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),

                      contentPadding: EdgeInsets.only(bottom: 15, left: 0),

                      // contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                      border: InputBorder.none,
                      hintText: '5XXXXXXXX',
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      // contentPadding: EdgeInsets.only(bottom: 0, left: 0),
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     phone_flag(txt_color, heightM),
            //     SizedBox(
            //       width: heightM,
            //     ),
            //     phone_text(txt_color, heightM),
            //   ],
            // ),
            SizedBox(
              height: heightM * 0.5,
            ),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: heightM * 1.5,
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10.0), //12
                  color: Colors.transparent, //Colors.cyan.withOpacity(0.5),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    color: button_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    splashColor: button_color,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (first_name.text.isEmpty) {
                          CoolAlert.show(
                            context: context,
                            title: "",
                            type: CoolAlertType.error,
                            text: "Please Enter Your First Name",
                            confirmBtnColor: button_color,
                          );
                        } else if (phone.text.isEmpty) {
                          CoolAlert.show(
                            context: context,
                            title: "",
                            type: CoolAlertType.error,
                            text: "Please Enter Correct Phone Number",
                            confirmBtnColor: button_color,
                          );
                        } else {
                          print("Done!");

                          //  phoneNumber =
                          //     "+${getCountryCode()}${phone.text}";
                          // openSheet(context, heightM, button_color, txt_color,
                          //     phoneNumber);

                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.loading,
                            text: "Loading",
                          );

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '${phoneNumber}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {
                              print("verificationCompleted: ${credential}");
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              print("verificationFailed: ${e}");
                              Navigator.of(context).pop();
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: 'Oops...',
                                text: '$e',
                                loopAnimation: false,
                              );
                            },
                            codeSent:
                                (String verificationId, int? resendToken) {
                              // print("codeSent: ${verificationId} , codeSent: ${resendToken}");
                              Navigator.of(context).pop();

                              openSheet(context, heightM, button_color,
                                  txt_color, phoneNumber, verificationId);
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              print("codeSent: ${verificationId}");
                            },
                          );
                        }
                      }
                    },
                    child: Text('Sign Up',
                        textAlign: TextAlign.center,
                        style: ourTextStyle(
                            txt_color: Colors.white, txt_size: heightM * 0.6)),
                  ),
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
                      text: "Have an Account? ",
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
      )),
    );
  }

  void openSheet(BuildContext context, heightM, button_color, txt_color,
      phoneNumber, verificationId) {
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
                Text(
                  'Enter OTP that sends to',
                  style: ourTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.7),
                ),
                Text(
                  '${phoneNumber}',
                  style: ourTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.7),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: VerificationCode(
                    textStyle: ourTextStyle(
                        txt_color: txt_color, txt_size: heightM * 0.4),
                    keyboardType: TextInputType.number,
                    fullBorder: true,
                    underlineColor:
                        button_color, // If this is null it will use primaryColor: Colors.red from Theme
                    length: 6,
                    cursorColor:
                        txt_color, // If this is null it will default to the ambient
                    // clearAll is NOT required, you can delete it
                    // takes any widget, so you can implement your design
                    clearAll: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          color: Colors
                              .transparent, //Colors.cyan.withOpacity(0.5),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.black45.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            splashColor: Colors.black45,
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: heightM * 1.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0), //12
                          color: Colors
                              .transparent, //Colors.cyan.withOpacity(0.5),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: button_color.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            splashColor: button_color,
                            onPressed: () async {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                text: "Loading",
                              );

                              // Create a PhoneAuthCredential with the code
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _code!);
                              // ConfirmationResult confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber('+962786183499');

                              // print("credential ${confirmationResult}");
                              print("credential ${credential}");
                              await finishOTPLogin(credential, button_color);
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
                )
              ],
            ),
          );
        });
  }

  finishOTPLogin(AuthCredential authCredential, button_color) async {
    //
    // setBusyForObject(otpLogin, true);
    // Sign the user in (or link) with the credential
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        authCredential,
      );
      //
      String firebaseToken = await userCredential.user!.getIdToken();
      String userUid = userCredential.user!.uid;
      // final apiResponse = await authRequest.verifyFirebaseToken(
      //   accountPhoneNumber,
      //   firebaseToken,
      // );

      Navigator.of(context).pop();

      await userSetup(
          userUid: userUid,
          firstName: first_name.text,
          phoneNumber: phoneNumber);

      print("ddd ${firebaseToken}");

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'SignUp completed successfully!',
      );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false);

      // print("ddd ${apiResponse.data}");
      // print("ddd ${apiResponse.message}");
      //
      // await handleDeviceLogin(apiResponse);
    } catch (error) {
      Navigator.of(context).pop();
      CoolAlert.show(
        context: context,
        title: "",
        type: CoolAlertType.error,
        text: "Code Error !",
        confirmBtnColor: button_color,
      );
      print("ddd_222 ${error}");

      // viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }

    // setBusyForObject(otpLogin, false);
  }

  Future<void> userSetup(
      {required String firstName,
      required String userUid,
      required String phoneNumber}) async {
    //firebase auth instance to get uuid of user
    // FirebaseAuth auth = FirebaseAuth.instance.currentUser!;

    //now below I am getting an instance of firebaseiestore then getting the user collection
    //now I am creating the document if not already exist and setting the data.
    FirebaseFirestore.instance.collection('Users').doc(userUid).set(
        {'firstName': firstName, 'phoneNumber': phoneNumber, 'uid': userUid});

    return;
  }

  // String getCountryCode() {
  //   if (country_selected != null) {
  //     return country_selected?.phoneCode ?? "";
  //   } else {
  //     return "$country_code";
  //   }
  // }

  // Widget first_name_text(Color txt_color, double heightM) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Card(
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.7,
  //           child: TextFormField(
  //             controller: first_name,
  //             cursorColor: Colors.black,
  //             // keyboardType: TextInputType.number,
  //             decoration: const InputDecoration(
  //                 border: InputBorder.none,
  //                 focusedBorder: InputBorder.none,
  //                 enabledBorder: InputBorder.none,
  //                 errorBorder: InputBorder.none,
  //                 disabledBorder: InputBorder.none,
  //                 contentPadding:
  //                     EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  //                 hintText: "Your First Name"),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget last_name_text(Color txt_color, double heightM) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(right: 8.0, left: 8.0),
  //         child: Text(
  //           "Last Name",
  //           style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.6),
  //         ),
  //       ),
  //       Card(
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.7,
  //           child: TextFormField(
  //             controller: last_name,
  //             cursorColor: Colors.black,
  //             // keyboardType: TextInputType.number,
  //             decoration: const InputDecoration(
  //                 border: InputBorder.none,
  //                 focusedBorder: InputBorder.none,
  //                 enabledBorder: InputBorder.none,
  //                 errorBorder: InputBorder.none,
  //                 disabledBorder: InputBorder.none,
  //                 contentPadding:
  //                     EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  //                 hintText: "Your Last Name"),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget phone_text(Color txt_color, double heightM) {
  //   return Column(
  //     children: [
  //       Text(
  //         "Phone Number",
  //         style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.6),
  //       ),
  //       Card(
  //         child: Container(
  //           width: heightM * 5,
  //           child: TextFormField(
  //             controller: phone,
  //             cursorColor: Colors.black,
  //             keyboardType: TextInputType.number,
  //             decoration: const InputDecoration(
  //                 border: InputBorder.none,
  //                 focusedBorder: InputBorder.none,
  //                 enabledBorder: InputBorder.none,
  //                 errorBorder: InputBorder.none,
  //                 disabledBorder: InputBorder.none,
  //                 contentPadding:
  //                     EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  //                 hintText: "5X XXXX XXXX"),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget phone_flag(Color txt_color, double heightM) {
  //   return Column(
  //     children: [
  //       Text(
  //         "Country Code",
  //         style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.6),
  //       ),
  //       Card(
  //         child: InkWell(
  //           onTap: () {
  //             showCountryPicker(
  //               context: context,
  //               showPhoneCode: true,
  //               onSelect: (Country selected) {
  //                 print("country: ${selected.flagEmoji}");
  //                 country_selected = selected;
  //                 setState(() {});
  //               },
  //             );
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.all(4.0),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   getCountryData(),
  //                   style: ourTextStyle(
  //                       txt_color: txt_color, txt_size: heightM * 0.6),
  //                 ),
  //                 // SizedBox(width: heightM * 0.5,),
  //                 const Padding(
  //                   padding: EdgeInsets.all(2.0),
  //                   child: Icon(Icons.keyboard_arrow_down_rounded),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // String getCountryData() {
  //   if (country_selected != null) {
  //     return '${country_selected?.flagEmoji ?? ""} +${country_selected?.phoneCode ?? ""}';
  //   } else {
  //     return '$country_flag $country_code';
  //   }
  // }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
  }
}
