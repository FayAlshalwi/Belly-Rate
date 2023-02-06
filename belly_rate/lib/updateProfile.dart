import 'dart:io';
import 'package:belly_rate/myProfile.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:belly_rate/auth/our_user_model.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:belly_rate/auth/signup_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  OurUser? ourUser;
  UpdateProfile({Key? key, this.ourUser}) : super(key: key);

  _UpdateProfile createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateProfile> {
  TextEditingController phone = TextEditingController();
  TextEditingController first_name = TextEditingController();
  bool flag = false;
  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    first_name.text = "${widget.ourUser?.name}";
    phone.text = "${widget.ourUser?.phone_number}";
  }

  @override
  Widget build(BuildContext context) {
    final Color txt_color = Color(0xFF5a3769);
    final Color button_color = Color.fromARGB(255, 216, 107, 147);
    final double heightM = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (flag)
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  text: 'Are you sure you want to discard your changes?',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'Cancel',
                  title: "Discard changes",
                  onCancelBtnTap: () {
                    Navigator.of(context).pop(true);
                  },
                  onConfirmBtnTap: () async {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  });
            else
              Navigator.of(context).pop(true);
          },
          color: Color(0xFF5a3769),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Update Profile",
          style: TextStyle(
            fontSize: 22,
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width / 2.29,
              height: MediaQuery.of(context).size.width / 2.29,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: GestureDetector(
                  onTap: () {
                    _selectImage(context);
                  }, // Image tapped

                  child: Stack(
                    children: <Widget>[
                      image == null
                          ? Container(
                              // decoration:
                              //     new BoxDecoration(
                              //         color:
                              //             Colors.white),
                              alignment: Alignment.center,
                              height: 240,

                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(400), // Image radius
                                  child: Image.network(
                                      "${widget.ourUser?.picture}",
                                      fit: BoxFit.cover, errorBuilder: (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return Image.network(
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
                                  }),
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: 240,
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(400), // Image radius
                                  child: Image.file(image!, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 30,
                        ),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        flag = true;
                      });
                      // formKey.currentState?.validate();
                      print(first_name.text);
                    },
                    validator: (value) {
                      final regExp = RegExp(r'^[a-zA-Z]+$');
                      String text = first_name.text;
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      } else if (!regExp.hasMatch(text.trim())) {
                        return 'You cannot enter special characters !@#\%^&*()';
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  TextFormField(
                    enabled: false,
                    controller: phone,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                      hintText: "Your Phone",
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(158, 158, 158, 1),
                          fontSize: 16),
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: heightM * 1.5,
                  child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(5.0), //12
                    color: Colors.transparent, //Colors.cyan.withOpacity(0.5),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      color: Color.fromARGB(255, 216, 107, 147),
                      // color: button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      splashColor: button_color,
                      // splashColor: button_color,
                      onPressed: () async {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            text:
                                'Are you sure you want to update your profile?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'Cancel',
                            title: "Update Profile",
                            onCancelBtnTap: () {
                              Navigator.of(context).pop(true);
                              Navigator.of(context).pop(true);
                            },
                            onConfirmBtnTap: () async {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                text: "Loading",
                              );

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "name": first_name.text,
                              });
                              if (image != null) await addPhoto(image!);

                              CoolAlert.show(
                                title: "Success",
                                context: context,
                                type: CoolAlertType.success,
                                text: "Profile updated successfuly!",
                                confirmBtnColor:
                                    Color.fromARGB(255, 216, 107, 147),
                                onConfirmBtnTap: () {
                                  Navigator.of(context).pop(true);
                                  Navigator.of(context).pop(true);
                                  Navigator.of(context).pop(true);
                                  Navigator.of(context).pop(true);
                                },
                              );
                            });
                      },
                      child: Text('Update',
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



  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
    return imageTemp;
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: const Text('Upload photo'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  addPhoto(File img) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform
        );
    String fileName = basename(img.path);

    //uploadImageToFirebase
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;

    Reference ref = firebaseStorageRef.ref().child('images/$fileName');
    UploadTask uploadTask = ref.putFile(img);

    final TaskSnapshot downloadUrl = (await uploadTask);

    final String url = await downloadUrl.ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "picture": url,
    });
  }

  TextStyle getMyTextStyle({required Color txt_color, double fontSize = 22}) {
    return GoogleFonts.cairo(
        color: txt_color, fontSize: fontSize, fontWeight: FontWeight.bold);
  }

  String UpdateName (String name ){

  final regExp = RegExp(r'^[a-zA-Z]+$');
  //case 1
     if (name == null || name.isEmpty) {
         return 'Please enter your name';}
  //case 2 
             else if (!regExp.hasMatch(name.trim())) {
                        return 'You cannot enter special characters !@#\%^&*()';}
   //case 3                     
                    else if (name.length <= 2) {
                        return "Please enter at least 3 characters";
                      }

return "Success";}

}
