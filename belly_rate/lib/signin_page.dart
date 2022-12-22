import 'package:belly_rate/auth/signup_page.dart';
import 'package:belly_rate/auth/welcome_page.dart';
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


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _onEditing = true;
  String? _code;

  Country? country_selected ;
  String? country_flag = "🇸🇦" ;
  String? country_code = "+966" ;
  TextEditingController phone  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height /30 ;
     Color txt_color = Color(0xff6168A3) ;
     Color button_color = Color(0xfff53c57) ;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heightM * 3 , ),
            Center(
              child: Image.asset("assets/auth/1.jpg" ,
               height: heightM * 10 ,
              fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.only(left:  30.0 , right: 30.0 , top: 8.0 ,bottom: 0.0),
              child: Text("Sign In" , style: ourTextStyle(txt_size: heightM, txt_color: txt_color ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:  30.0 , right: 30.0 , top: 0.0 ,bottom: 8.0),
              child: Text("Hi there! Nice to see you again" , style: ourTextStyle(txt_size: heightM * 0.7, txt_color: Colors.black45 ),),
            ),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 phone_flag(txt_color, heightM),
                 SizedBox(width: heightM,),
                 phone_text(txt_color, heightM),
               ],
             ),
            SizedBox(height: heightM,),
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
                    color: button_color.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    splashColor: button_color,
                    onPressed: () async {
                      if (phone.text.isNotEmpty) {
                        // print("phone: ${phone.text}");
                        String phoneNumber =
                           "+${getCountryCode()}${phone.text}";
                        // openSheet(context, heightM, button_color, txt_color,
                        //     phoneNumber);

                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.loading,
                          text: "Loading",
                        );

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '${phoneNumber}',
                          verificationCompleted: (PhoneAuthCredential credential) {
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
                          codeSent: (String verificationId, int? resendToken) {
                            // print("codeSent: ${verificationId} , codeSent: ${resendToken}");
                            Navigator.of(context).pop();


                            openSheet(context, heightM, button_color, txt_color, phoneNumber , verificationId);

                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            print("codeSent: ${verificationId}");
                          },
                        );


                      } else {
                        CoolAlert.show(
                          context: context,
                          title: "",
                        type: CoolAlertType.error,
                        text: "Please Enter Correct Phone Number",
                        confirmBtnColor: button_color,
                    );
                  }

                },
                child: Text('Sign In',
                    textAlign: TextAlign.center,
                    style: ourTextStyle(txt_color: Colors.white, txt_size: heightM * 0.6)),
              ),
            ),
          ),
        ),
            SizedBox(height: heightM * 0.5,),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Didn't Have an Account? ",
                      style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.55),
                    ),
                    TextSpan(
                      text: ' Sign Up',
                      style: ourTextStyle(txt_color: button_color, txt_size: heightM * 0.55),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        print("Sign Up");
                        // SignUpPage
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SignUpPage()));
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

  void openSheet(BuildContext context , heightM , button_color ,txt_color , phoneNumber , verificationId ){
    showModalBottomSheet(
        context: context,
        elevation: 20,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled : true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Text(
                  'Enter OTP that sends to',
                  style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.7),
                ),

                Text(
                  '${phoneNumber}',
                  style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.7),
                ),


                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: VerificationCode(
                    textStyle: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.4),
                    keyboardType: TextInputType.number,
                    fullBorder: true,
                    underlineColor: button_color, // If this is null it will use primaryColor: Colors.red from Theme
                    length: 6,
                    cursorColor: txt_color, // If this is null it will default to the ambient
                    // clearAll is NOT required, you can delete it
                    // takes any widget, so you can implement your design
                    clearAll: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'clear all'.toUpperCase(),
                        style: ourTextStyle(txt_color: txt_color, txt_size: heightM * 0.5),
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
                          borderRadius: BorderRadius.circular(10.0),//12
                          color: Colors.transparent,//Colors.cyan.withOpacity(0.5),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.black45.withOpacity(0.7),
                            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0) ),
                            splashColor: Colors.black45,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Back',
                                textAlign: TextAlign.center,
                                style: ourTextStyle(txt_color: Colors.white, txt_size: heightM * 0.6)),
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
                          borderRadius: BorderRadius.circular(10.0),//12
                          color: Colors.transparent,//Colors.cyan.withOpacity(0.5),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: button_color.withOpacity(0.7),
                            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0) ),
                            splashColor: button_color,
                            onPressed: () async {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                text: "Loading",
                              );

                              // Create a PhoneAuthCredential with the code
                              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _code!);
                              // ConfirmationResult confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber('+962786183499');

                              // print("credential ${confirmationResult}");
                              print("credential ${credential}");
                              await finishOTPLogin(credential ,button_color);

                            },
                            child: Text('Sign In',
                                textAlign: TextAlign.center,
                                style: ourTextStyle(txt_color: Colors.white, txt_size: heightM * 0.6)),
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

  finishOTPLogin(AuthCredential authCredential ,button_color) async {
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

      final user = await userSetup(userUid: userUid , firstName:  "" , lastName: "");

      // print("ddd ${userCredential.user?.email}");
      // print("ddd ${firebaseToken}");
      print("ddd ${user}");
      print("ddd ${user.get("firstName")}");

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Transaction completed successfully!',
      );


      /// WelcomePage

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));


    } catch (error) {
      Navigator.of(context).pop();
      String Error = "" ;
      print("e ${error}");


      if(error.toString().contains("does not exist")) {
        Error = "User Not Exist! , Please Go to Sign Up Page" ;
      }else  if(error.toString().contains("The sms verification code used to create the phone auth credential is invalid")) {
        Error = "Code Error !" ;
      }

      CoolAlert.show(
        context: context,
        title: "",
        type: CoolAlertType.error,
        text: Error,
        confirmBtnColor: button_color,
      );


      print("ddd_222 ${error}");

      // viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }

    // setBusyForObject(otpLogin, false);
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> userSetup(
      {required String firstName, required String lastName, required String userUid}) async {

    // FirebaseFirestore.instance.collection('Users').doc(userUid).get(
    //     {
    //       'firstName': firstName,
    //       'lastName': lastName,
    //       'uid': userUid
    //     });

    final user = await FirebaseFirestore.instance.collection('Users').doc(userUid).get();


    return user ;
  }


  Widget phone_flag(Color txt_color, double heightM) {
    return Column(
      children: [
        Text("Country Code" ,  style: ourTextStyle(
            txt_color: txt_color, txt_size: heightM * 0.6), ),
        Card(
          child: InkWell(
            onTap: (){
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country selected){
                  print("country: ${selected.flagEmoji}");
                  country_selected = selected ;
                  setState(() {});
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                                  getCountryData(),
                                  style: ourTextStyle(
                                      txt_color: txt_color, txt_size: heightM * 0.6),
                                ),
                  // SizedBox(width: heightM * 0.5,),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(Icons.keyboard_arrow_down_rounded),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phone_text(Color txt_color, double heightM) {
    return Column(
      children: [
        Text("Phone Number" ,  style: ourTextStyle(
            txt_color: txt_color, txt_size: heightM * 0.6), ),
        Card(
          child: Container(
            width: heightM * 5,
            child: TextFormField(
              controller: phone,
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "5X XXXX XXXX"),
            ),
          ),
        ),
      ],
    );
  }

  String getCountryData(){
    if(country_selected != null){
      return '${country_selected?.flagEmoji?? ""} +${country_selected?.phoneCode?? ""}' ;
    }else{
      return '$country_flag $country_code' ;
    }
  }

  String getCountryCode(){
    if(country_selected != null){
      return country_selected?.phoneCode?? "" ;
    }else{
      return "$country_code" ;
    }
  }


  TextStyle ourTextStyle({required Color txt_color  ,required double txt_size }) {
    return GoogleFonts.cairo(
          color: txt_color ,
          fontWeight: FontWeight.bold,
          fontSize: txt_size
        );
  }
}