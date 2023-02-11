import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_btn/loading_btn.dart';
import '../category_parts/restaurant_model.dart';
import 'HomePageManger.dart';
import 'mapPage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddRestaurants extends StatefulWidget {
  const AddRestaurants({Key? key}) : super(key: key);

  @override
  State<AddRestaurants> createState() => _AddRestaurantsState();
}

class _AddRestaurantsState extends State<AddRestaurants> {
  bool invalidID = false;
  bool invalidName = false;
  bool invalidDes = false;
  bool invalidPHnum = false;
  bool invalidLat = false;
  bool invalidLong = false;

  TextEditingController restaurantDescription = TextEditingController();
  TextEditingController restaurantLat = TextEditingController();
  TextEditingController restaurantLong = TextEditingController();
  TextEditingController restaurantId = TextEditingController();
  TextEditingController restaurantName = TextEditingController();
  TextEditingController restaurantPhoneNumber = TextEditingController();
  String restaurantLatAuto = "";
  String restaurantLongAuto = "";
  List<File?> _imageFiles = [];
  List<String> _imageFilesString = [];
  List<String> _listCheckResID = [];

  final List<String> _listCategory = [
    "",
    "Italian",
    'Seafood',
    'Health food',
    'Indian',
    'American',
    'Lebanese',
    'Japanese',
    'French'
  ];
  final List<String> _listPriceAvg = ["", "Low", 'Medium', 'High'];
  String _selectedPriceAvg = "";
  String _selectedCategory = "";
  int _selectedOption = 1;
  // final _formKey = GlobalKey<FormState>();
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyId = GlobalKey<FormState>();
  final _formKeyDes = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyLat = GlobalKey<FormState>();
  final _formKeyLong = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckResID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Add Restaurant",
          style: TextStyle(
            fontSize: 22,
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // child: dd(),
        child: buildForm(context),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),

        Form(
            key: _formKeyId,
            child: buildContainerTextFieldRestaurantId(
                keyboardType: TextInputType.number,
                textEditingController: restaurantId,
                ourLabelText: "Restaurant ID")),

        Form(
            key: _formKeyName,
            child: buildContainerTextFieldRestaurantName(
                textEditingController: restaurantName,
                ourLabelText: "Restaurant Name")),

        Form(
            key: _formKeyDes,
            child: buildContainerTextFieldRestaurantDescription(
                textEditingController: restaurantDescription,
                ourLabelText: "Restaurant Description")),
        Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      'Restaurnat category',
                      textAlign: TextAlign.start,
                      style: ourTextStyle(
                          txt_color: Color(0xFF5a3769), txt_size: 16),
                    ),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.center,
                  height: 60,
                  margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                    DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _listCategory.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    )
                  ]),
                ),
              ],
            )),

        Form(
            key: _formKeyPhone,
            child: buildContainerTextFieldPhoneNumber(
                textEditingController: restaurantPhoneNumber,
                ourLabelText: "Restaurant Phone Number",
                keyboardType: TextInputType.number)),

        /// Price Avg - drop down
        Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      "Price Average",
                      textAlign: TextAlign.start,
                      style: ourTextStyle(
                          txt_color: Color(0xFF5a3769), txt_size: 16),
                    ),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.center,
                  height: 60,
                  margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                    DropdownButton<String>(
                      value: _selectedPriceAvg,
                      isExpanded: true,
                      items: _listPriceAvg.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPriceAvg = newValue!;
                        });
                      },
                    ),
                  ]),
                ),
              ],
            )),
        Container(
            alignment: AlignmentDirectional.centerStart,
            margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            child: Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      "Choose method to add restaurant location",
                      textAlign: TextAlign.start,
                      style: ourTextStyle(
                          txt_color: Color(0xFF5a3769), txt_size: 16),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text("Manually",
                              style: ourTextStyle(
                                  txt_color: mainColor(), txt_size: 15)),
                          value: 1,
                          groupValue: _selectedOption,
                          activeColor: mainColor(),
                          onChanged: (value) {
                            restaurantLatAuto = "";
                            restaurantLongAuto = "";
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text("From Map",
                              style: ourTextStyle(
                                  txt_color: mainColor(), txt_size: 15)),
                          value: 2,
                          groupValue: _selectedOption,
                          activeColor: mainColor(),
                          onChanged: (value) {
                            restaurantLat.clear();
                            restaurantLong.clear();
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),

        if (_selectedOption == 1)
          Column(
            children: [
              Form(
                  key: _formKeyLat,
                  child: buildContainerTextFieldLat(
                      textEditingController: restaurantLat,
                      ourLabelText: "Restaurant Latitude",
                      keyboardType: TextInputType.number)),
              Form(
                  key: _formKeyLong,
                  child: buildContainerTextFieldLong(
                      textEditingController: restaurantLong,
                      ourLabelText: "Restaurant Longitude",
                      keyboardType: TextInputType.number)),
            ],
          ),
        if (_selectedOption == 2)
          buildContainerOpenMap(
              textEditingControllerLat: restaurantLat,
              textEditingControllerLong: restaurantLong,
              ourLabelText: "Open Map"),

        /// add image text
        Container(
          margin: const EdgeInsets.fromLTRB(23, 02, 10, 10),
          child: Row(
            children: [
              Text(
                "Add restaurant photos (4 photos are required)",
                style: ourTextStyle(txt_color: mainColor(), txt_size: 15),
              ),
            ],
          ),
        ),

        /// add image
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageFiles.length + 1,
            itemBuilder: (context, index) {
              if (index == _imageFiles.length) {
                if (_imageFiles.length < 4) {
                  return Container(
                    width: 150,
                    child: IconButton(
                      icon: Icon(Icons.add_photo_alternate),
                      onPressed: () {
                        if (_imageFiles.length < 4) {
                          _selectImage(context);
                        } else {}
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
              return Container(
                width: 150,
                child: Image.file(_imageFiles[index]!),
              );
            },
          ),
        ),

        /// Add Restaurant
        ///
        Center(
          child: Container(
            child: LoadingBtn(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 24 * 1.5,
              color: Color.fromARGB(255, 216, 107, 147),
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
              child: Text(
                "Add Restaurant",
                textAlign: TextAlign.center,
                style:
                    getMyTextStyle(txt_color: Colors.white, fontSize: 25 * 0.6),
              ),

              onTap: (startLoading, stopLoading, btnState) async {
                if (_formKeyId.currentState!.validate() &&
                    _formKeyName.currentState!.validate() &&
                    _formKeyDes.currentState!.validate() &&
                    _formKeyPhone.currentState!.validate() &&
                    _formKeyLat.currentState!.validate() &&
                    _formKeyLong.currentState!.validate()) {
                  if (_imageFiles.length < 4) {
                    CoolAlert.show(
                      context: context,
                      title: "Image's less than 4",
                      type: CoolAlertType.error,
                      text: "Please choose exactly 4 pictures ",
                      confirmBtnColor: const Color.fromARGB(255, 216, 107, 147),
                    );
                  } else {
                    startLoading();
                    List<Future> futures = [];
                    _imageFiles.forEach((photo) async {
                      futures.add(addPhoto(photo!));
                    });
                    await Future.wait(futures);

                    bool isGood = await addRestaurantMethod();

                    if (isGood) {
                      CoolAlert.show(
                          context: context,
                          title: "Restaurant Add",
                          type: CoolAlertType.success,
                          text: "Restaurant Added Successfully",
                          confirmBtnColor:
                              const Color.fromARGB(255, 216, 107, 147),
                          onConfirmBtnTap: () {
                            stopLoading();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePageManger()),
                                (Route<dynamic> route) => false);
                          });
                    } else {
                      CoolAlert.show(
                          context: context,
                          title: "Error",
                          type: CoolAlertType.error,
                          text: "Please Try Again",
                          confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                          onConfirmBtnTap: () {
                            stopLoading();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                    }
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future addRestaurantMethod() async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore.collection("Restaurants").add({
      'ID': '',
      'category': '${_selectedCategory}',
      'description': '${restaurantDescription.text}',
      'lat': '${_selectedOption == 1 ? restaurantLat.text : restaurantLatAuto}',
      'long':
          '${_selectedOption == 1 ? restaurantLong.text : restaurantLongAuto}',
      'name': '${restaurantName.text}',
      'phoneNumber': '${restaurantPhoneNumber.text}',
      'priceAvg': '${_selectedPriceAvg}',
      "photos": _imageFilesString,
    }).then((value) async {
      print("wwww ${value.id}");
      await _firestore
          .collection("Restaurants")
          .doc(value.id)
          .update({"ID": value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Container buildContainerTextFieldLat(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  ourLabelText,
                  textAlign: TextAlign.start,
                  style:
                      ourTextStyle(txt_color: Color(0xFF5a3769), txt_size: 16),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              height: 60,
              margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                  keyboardType: keyboardType,
                  controller: textEditingController,
                  onChanged: (value) {
                    _formKeyLat.currentState!.validate();
                  },
                  validator: (value) {
                    String pattern = r'^[0-9.]+$';
                    RegExp regExp = new RegExp(pattern);
                    if (value!.isEmpty) {
                      invalidLat = true;
                      return "Please enter latitude";
                    }
                    if (!regExp.hasMatch(value)) {
                      invalidLat = true;
                      return "Enter numbers Only";
                    }
                    if (value.length > 18) {
                      invalidLat = true;
                      return "Max input length is 18.";
                    } else {
                      invalidLat = false;
                      return null;
                    }
                  },
                  maxLength: 18,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  Container buildContainerTextFieldLong(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  ourLabelText,
                  textAlign: TextAlign.start,
                  style:
                      ourTextStyle(txt_color: Color(0xFF5a3769), txt_size: 16),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              height: 60,
              margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                  keyboardType: keyboardType,
                  controller: textEditingController,
                  onChanged: (value) {
                    _formKeyLong.currentState!.validate();
                  },
                  validator: (value) {
                    String pattern = r'^[0-9.]+$';
                    RegExp regExp = new RegExp(pattern);
                    if (value!.isEmpty) {
                      invalidLong = true;
                      return "Please enter longitude";
                    }
                    if (!regExp.hasMatch(value)) {
                      invalidLong = true;
                      return "Enter numbers Only";
                    }
                    if (value.length > 18) {
                      invalidLong = true;
                      return "Max input length is 18.";
                    } else {
                      invalidLong = false;
                      return null;
                    }
                  },
                  maxLength: 18,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  Container buildContainerTextFieldPhoneNumber(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  ourLabelText,
                  textAlign: TextAlign.start,
                  style:
                      ourTextStyle(txt_color: Color(0xFF5a3769), txt_size: 16),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              height: 60,
              margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                  keyboardType: keyboardType,
                  controller: textEditingController,
                  onChanged: (value) {
                    _formKeyPhone.currentState!.validate();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      invalidPHnum = true;
                      return "Please enter resturant Phone number";
                    }
                    if (RegExp(r"[a-zA-Z!@#\$%^&*()_+|~=`{}\[\]:;'<>?,.\/\\-]")
                        .hasMatch(value)) {
                      invalidPHnum = true;
                      return "Only numbers allowed";
                    }
                    if (value.length != 10) {
                      invalidPHnum = true;
                      return "Please enter 10 numbers";
                    } else {
                      invalidPHnum = false;
                      return null;
                    }
                  },
                  maxLength: 10,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  Container buildContainerTextFieldRestaurantName(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  ourLabelText,
                  textAlign: TextAlign.start,
                  style:
                      ourTextStyle(txt_color: Color(0xFF5a3769), txt_size: 16),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              height: 60,
              margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                  keyboardType: keyboardType,
                  controller: textEditingController,
                  onChanged: (value) {
                    _formKeyName.currentState!.validate();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      invalidName = true;
                      return "Please enter resturant name";
                    }
                    if (value.length < 3) {
                      invalidName = true;
                      return "Please enter at least 3 characters";
                    } else if (value.length > 12) {
                      invalidName = true;
                      return "Max input length is 12 characters.";
                    }
                    //else if (value.contains(new RegExp(r'[0-9]'))) {
                    //invalidName = true;
                    //return "No numbers allowed.";
                    //}
                    else if (value.contains(new RegExp(r'[^a-zA-Z\s]'))) {
                      invalidName = true;
                      return "You cannot enter special characters";
                    } else {
                      invalidName = false;
                      return null;
                    }
                  },
                  maxLength: 12,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                    hintText: "Enter resturant name",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  Container buildContainerTextFieldRestaurantId(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  ourLabelText,
                  textAlign: TextAlign.start,
                  style:
                      ourTextStyle(txt_color: Color(0xFF5a3769), txt_size: 16),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              height: 60,
              margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                  controller: textEditingController,
                  keyboardType: keyboardType,
                  onChanged: (value) {
                    _formKeyId.currentState!.validate();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      invalidID = true;
                      return "Please enter resturant ID";
                    } else if (int.tryParse(value) == null) {
                      invalidID = true;
                      return "Enter a valid Resuturant ID.";
                    } else if (value.length > 6) {
                      invalidID = true;
                      return "Resuturant ID can't be longer than 6 digits.";
                    }
                    if (_listCheckResID.contains(value)) {
                      invalidID = true;
                      return "Restaurant ID is not unique.";
                    } else {
                      invalidID = false;
                      return null;
                    }
                  },
                  maxLength: 6,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                    hintText: "Enter resturant ID",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  Container buildContainerTextFieldRestaurantDescription(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.fromLTRB(5, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  ourLabelText,
                  textAlign: TextAlign.start,
                  style:
                      ourTextStyle(txt_color: Color(0xFF5a3769), txt_size: 16),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              // height: 60,
              margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
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
                  maxLines: null,
                  minLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: textEditingController,
                  onChanged: (value) {
                    _formKeyDes.currentState!.validate();
                  },
                  validator: (value) {
                    final RegExp regex = RegExp(r"^[a-zA-Z0-9 \n.]+$");

                    if (value!.isEmpty) {
                      invalidDes = true;
                      return "Please enter resturant description";
                    }
                    if (!regex.hasMatch(value)) {
                      invalidDes = true;
                      return "You cannot enter special characters";
                    }
                    if (value.length < 3) {
                      invalidDes = true;
                      return "Please enter at least 3 characters";
                    }
                    if (value.length > 120) {
                      invalidDes = true;
                      return "Max input length is 120 characters.";
                    } else {
                      invalidDes = false;
                      return null;
                    }
                  },
                  maxLength: 120,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                    hintText: "Enter resturant description",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  Widget buildContainerOpenMap(
      {required TextEditingController textEditingControllerLat,
      required TextEditingController textEditingControllerLong,
      required String ourLabelText}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage()),
        ).then((value) {
          if (value != null) {
            value as List<dynamic>;
            print(value);
            setState(() {
              // nameLocation = value[2] ;
              restaurantLatAuto = value[0].toString();
              restaurantLongAuto = value[1].toString();
              textEditingControllerLat.text = value[0].toString();
              textEditingControllerLong.text = value[1].toString();
              print("lattt= ${restaurantLatAuto}");
              print("longg= ${restaurantLongAuto}");
            });
          }
        });
      },
      child: Container(
        alignment: AlignmentDirectional.center,
        width: 380,
        height: 60,
        margin: const EdgeInsets.fromLTRB(23, 02, 10, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withOpacity(0.13)),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffeeeeee),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (restaurantLatAuto.isEmpty && restaurantLongAuto.isEmpty)
              Container(
                child: Text("Open Map",
                    style: ourTextStyle(txt_color: mainColor(), txt_size: 13)),
              ),
            if (restaurantLatAuto.isNotEmpty && restaurantLongAuto.isNotEmpty)
              Container(
                child: Text(
                    "Lat: ${restaurantLatAuto} , Long: ${restaurantLongAuto}",
                    style: ourTextStyle(txt_color: mainColor(), txt_size: 13)),
              ),
          ],
        ),
      ),
    );
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

  void pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => _imageFiles.add(imageTemp));
    // return imageTemp;
  }

  Future addPhoto(File img) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform
        );
    String fileName = path.basename(img.path);

    //uploadImageToFirebase
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;

    Reference ref = firebaseStorageRef.ref().child('images/$fileName');
    UploadTask uploadTask = ref.putFile(img);

    final TaskSnapshot downloadUrl = (await uploadTask);

    final String url = await downloadUrl.ref.getDownloadURL();
    print("wwww add image");
    _imageFilesString.add(url);
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
      color: txt_color,
      fontWeight: FontWeight.bold,
      fontSize: txt_size,
    );
  }

  Future CheckResID() async {
    final _firestore = FirebaseFirestore.instance;
    final _firebaseAuth = FirebaseAuth.instance;

    final restaurants = await FirebaseFirestore.instance
        .collection('Restaurants')
        // .where("ID", isEqualTo: restaurantId)
        .get();

    for (var res in restaurants.docs) {
      // final body = json.encode(Category.data().toString());
      // log("Res: ${body}");
      // final restaurant = restaurantFromJson(Category.data().toString());
      final restaurant = Restaurant.fromJson(res.data()) as Restaurant;
      _listCheckResID.add(restaurant.id!);
    }
    setState(() {});
  }

  Color mainColor() => const Color(0xFF5a3769);
}

TextStyle getMyTextStyle({required Color txt_color, double fontSize = 22}) {
  return GoogleFonts.cairo(
      color: txt_color, fontSize: fontSize, fontWeight: FontWeight.bold);
}
