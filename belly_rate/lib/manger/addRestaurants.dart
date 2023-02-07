import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
  final List<String> _listCategory = [
    "",
    "Italian",
    'Seafood',
    'Health food',
    'Indian',
    'American',
    'Lebanese',
    'Japanese',
    'Other'
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
          child: Center(
              child: Text(
            "Enter the information for the restaurant you wish to add.",
            style: ourTextStyle(txt_color: mainColor(), txt_size: 18),
          )),
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

        /// Category - drop down
        Container(
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
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text("Select Category",
                      style:
                          ourTextStyle(txt_color: mainColor(), txt_size: 13))),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _listCategory.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style:
                            ourTextStyle(txt_color: mainColor(), txt_size: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        Form(
            key: _formKeyPhone,
            child: buildContainerTextFieldPhoneNumber(
                textEditingController: restaurantPhoneNumber,
                ourLabelText: "Restaurant Phone Number",
                keyboardType: TextInputType.number)),

        /// Price Avg - drop down
        Container(
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
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text("Select Price Average",
                      style:
                          ourTextStyle(txt_color: mainColor(), txt_size: 13))),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedPriceAvg,
                  isExpanded: true,
                  items: _listPriceAvg.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style:
                            ourTextStyle(txt_color: mainColor(), txt_size: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriceAvg = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(23, 02, 10, 10),
          // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Center(
              child: Text(
            "What method would you like to use to add the location of the restaurant?",
            style: ourTextStyle(txt_color: mainColor(), txt_size: 15),
          )),
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text("Manually",
                      style:
                          ourTextStyle(txt_color: mainColor(), txt_size: 15)),
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
                      style:
                          ourTextStyle(txt_color: mainColor(), txt_size: 15)),
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
        if (_selectedOption == 1)
          Row(
            children: [
              Expanded(
                  child: Form(
                      key: _formKeyLat,
                      child: buildContainerTextFieldLat(
                          textEditingController: restaurantLat,
                          ourLabelText: "Restaurant Lat",
                          keyboardType: TextInputType.number))),
              Expanded(
                  child: Form(
                      key: _formKeyLong,
                      child: buildContainerTextFieldLong(
                          textEditingController: restaurantLong,
                          ourLabelText: "Restaurant Long",
                          keyboardType: TextInputType.number))),
            ],
          ),
        if (_selectedOption == 2)
          buildContainerOpenMap(
              textEditingController: restaurantPhoneNumber,
              ourLabelText: "Open Map"),

        /// add image text
        Container(
          margin: const EdgeInsets.fromLTRB(23, 02, 10, 10),
          // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            children: [
              Text(
                "Add image to the restaurant: (min 1 - max 4)",
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
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Color.fromARGB(255, 216, 107, 147),
            onPressed: () async {
              if (restaurantName.text.isEmpty) {
                CoolAlert.show(
                  context: context,
                  title: "Name Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The Name",
                  confirmBtnTextStyle:
                      ourTextStyle(txt_color: Colors.white, txt_size: 13),
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (restaurantDescription.text.isEmpty) {
                CoolAlert.show(
                  context: context,
                  title: "Description Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The Description",
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (_selectedCategory.isEmpty) {
                CoolAlert.show(
                  context: context,
                  title: "Category Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The Category",
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (restaurantPhoneNumber.text.isEmpty) {
                CoolAlert.show(
                  context: context,
                  title: "Phone Number Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The Phone Number",
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (_selectedPriceAvg.isEmpty) {
                CoolAlert.show(
                  context: context,
                  title: "Price Average Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The Price Average",
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (_selectedOption == 1 &&
                  (restaurantLat.text.isEmpty || restaurantLong.text.isEmpty)) {
                CoolAlert.show(
                  context: context,
                  title: "Restaurant Location Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The restaurant Location",
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (_selectedOption == 2 &&
                  (restaurantLatAuto.isEmpty || restaurantLongAuto.isEmpty)) {
                CoolAlert.show(
                  context: context,
                  title: "Restaurant Location Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The restaurant Location",
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                );
              } else if (_imageFiles.isEmpty) {
                CoolAlert.show(
                  context: context,
                  title: "Restaurant Image Empty",
                  type: CoolAlertType.error,
                  text: "Please Fill The Restaurant Image",
                  confirmBtnColor: const Color.fromARGB(255, 216, 107, 147),
                );
              } else {
                CoolAlert.show(
                  context: context,
                  title: "Loading ...",
                  type: CoolAlertType.loading,
                );
                List<Future> futures = [];
                _imageFiles.forEach((photo) async {
                  futures.add(addPhoto(photo!));
                });
                await Future.wait(futures);

                // _imageFiles.forEach((element) async {
                //   await addPhoto(element!);
                // });

                bool isGood = await addRestaurantMethod();

                if (isGood) {
                  CoolAlert.show(
                      context: context,
                      title: "Restaurant Add",
                      type: CoolAlertType.success,
                      text: "Restaurant Added Successfully",
                      confirmBtnColor: const Color.fromARGB(255, 216, 107, 147),
                      onConfirmBtnTap: () {
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                }
              }
            },
            child: Text(
              "Add Restaurant",
              style: ourTextStyle(
                txt_color: Colors.white, //Colors.orange,
                txt_size: 15,
              ),
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
          '${_selectedOption == 1 ? restaurantLong.text : restaurantLong.text}',
      'name': '${restaurantName.text}',
      'phoneNumber': '${restaurantPhoneNumber.text}',
      'priceAvg': '${_selectedPriceAvg}',
      "photos": _imageFilesString,
      // "photos": [
      //   "item1",
      //   "item2",
      //   "item3",
      // ],
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

  ///Last Text Input
  // Container buildContainerTextField(
  //     {required TextEditingController textEditingController,required String ourLabelText ,TextInputType keyboardType = TextInputType.text }) {
  //   return Container(
  //         alignment: AlignmentDirectional.center,
  //         width: 380,
  //         // height: 80,
  //         margin: const EdgeInsets.fromLTRB(23, 02, 10, 10),
  //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: Colors.black.withOpacity(0.13)),
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Color(0xffeeeeee),
  //               blurRadius: 10,
  //               offset: Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: TextFormField(
  //           keyboardType: keyboardType,
  //           controller: textEditingController,
  //           cursorColor: Colors.black,
  //           // keyboardType: TextInputType.number,
  //           decoration: InputDecoration(
  //             errorStyle: TextStyle(height: 0),
  //             border: InputBorder.none,
  //             focusedBorder: InputBorder.none,
  //             enabledBorder: InputBorder.none,
  //             errorBorder: InputBorder.none,
  //             disabledBorder: InputBorder.none,
  //             contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
  //             labelText: ourLabelText,
  //             labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
  //             hintStyle: const TextStyle(
  //                 color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
  //           ),
  //           validator: (value) {
  //             if (value!.length < 3) {
  //               return "Min input length is 3 characters.";
  //             }else  if (value!.length > 20) {
  //               return "Max input length is 20 characters.";
  //             } else if (value.contains(new RegExp(r'[0-9]'))) {
  //               return "No numbers allowed.";
  //             } else if (value.contains(new RegExp(r'[^a-zA-Z\s]'))) {
  //               return "No special characters allowed.";
  //             }
  //             return null;
  //           },
  //         ),
  //       );
  // }
  //
  //

  Container buildContainerTextFieldLat(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 380,
      // height: 80,
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
      child: TextFormField(
        keyboardType: keyboardType,
        controller: textEditingController,
        cursorColor: Colors.black,
        onChanged: (_) {
          _formKeyLat.currentState!.validate();
        },
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: ourTextStyle(txt_color: Colors.red, txt_size: 13),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
          labelText: ourLabelText,
          labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
          hintStyle: const TextStyle(
              color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Field cant be empty";
          }
          String pattern = r'^[0-9.]+$';
          RegExp regExp = new RegExp(pattern);
          if (!regExp.hasMatch(value!)) {
            return "Enter numbers only";
          }
          if (value!.length > 18) {
            return "Max input length is 18.";
          }

          return null;
        },
      ),
    );
  }

  Container buildContainerTextFieldLong(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 380,
      // height: 80,
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
      child: TextFormField(
        keyboardType: keyboardType,
        controller: textEditingController,
        cursorColor: Colors.black,
        onChanged: (_) {
          _formKeyLong.currentState!.validate();
        },
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: ourTextStyle(txt_color: Colors.red, txt_size: 13),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
          labelText: ourLabelText,
          labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
          hintStyle: const TextStyle(
              color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "field cant be empty";
          }
          String pattern = r'^[0-9.]+$';
          RegExp regExp = new RegExp(pattern);
          if (!regExp.hasMatch(value!)) {
            return "Enter numbers Only";
          }
          if (value!.length > 18) {
            return "Max length is 18.";
          }
          return null;
        },
      ),
    );
  }

  Container buildContainerTextFieldPhoneNumber(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 380,
      // height: 80,
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
      child: TextFormField(
        keyboardType: keyboardType,
        controller: textEditingController,
        onChanged: (_) {
          _formKeyPhone.currentState!.validate();
        },
        cursorColor: Colors.black,
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: ourTextStyle(txt_color: Colors.red, txt_size: 13),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
          labelText: ourLabelText,
          labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
          hintStyle: const TextStyle(
              color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Phone number cant be empty";
          }
          if (RegExp(r"[a-zA-Z!@#\$%^&*()_+|~=`{}\[\]:;'<>?,.\/\\-]")
              .hasMatch(value!)) {
            return "No English letters or special characters allowed";
          }
          if (value!.length != 10) {
            return "Length must be equal to 10";
          }
          return null;
        },
      ),
    );
  }

  Container buildContainerTextFieldRestaurantName(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 380,
      // height: 80,
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
      child: TextFormField(
        keyboardType: keyboardType,
        controller: textEditingController,
        cursorColor: Colors.black,
        onChanged: (_) {
          _formKeyName.currentState!.validate();
        },
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: ourTextStyle(txt_color: Colors.red, txt_size: 13),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
          labelText: ourLabelText,
          labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
          hintStyle: const TextStyle(
              color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Resturant name cant be empty";
          }
          if (value!.length < 3) {
            return "Min input length is 3 characters.";
          } else if (value!.length > 12) {
            return "Max input length is 12 characters.";
          } else if (value.contains(new RegExp(r'[0-9]'))) {
            return "No numbers allowed.";
          } else if (value.contains(new RegExp(r'[^a-zA-Z\s]'))) {
            return "No special characters allowed.";
          }

          return null;
        },
      ),
    );
  }

  Container buildContainerTextFieldRestaurantId(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 380,
      // height: 80,
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
      child: TextFormField(
        keyboardType: keyboardType,
        controller: textEditingController,
        cursorColor: Colors.black,
        onChanged: (_) {
          _formKeyId.currentState!.validate();
        },
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: ourTextStyle(txt_color: Colors.red, txt_size: 13),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
          labelText: ourLabelText,
          labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
          hintStyle: const TextStyle(
              color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return "Resturant ID can't be empty.";
          } else if (int.tryParse(value) == null) {
            return "only numbers are allowed";
          }
          // else if (value.contains(new RegExp(r'[^a-zA-Z\s]'))) {
          //   return "No special characters allowed.";
          // }
          else if (value.length > 6) {
            return "Resturant ID can't be longer than 6 digits.";
          }
          return null;
        },
      ),
    );
  }

  Container buildContainerTextFieldRestaurantDescription(
      {required TextEditingController textEditingController,
      required String ourLabelText,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 380,
      // height: 80,
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
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        controller: textEditingController,
        // maxLines: 5,
        // expands: true,
        maxLines: null,
        minLines: null,
        cursorColor: Colors.black,
        onChanged: (_) {
          _formKeyDes.currentState!.validate();
        },
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: ourTextStyle(txt_color: Colors.red, txt_size: 13),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 04, left: 0),
          labelText: ourLabelText,
          labelStyle: ourTextStyle(txt_color: mainColor(), txt_size: 13),
          hintStyle: const TextStyle(
              color: Color.fromRGBO(158, 158, 158, 1), fontSize: 16),
        ),
        validator: (value) {
          // String pattern = r'^[a-zA-Z0-9]+$';
          // final RegExp regex = RegExp(r"^[a-zA-Z0-9 ]+$");
          final RegExp regex = RegExp(r"^[a-zA-Z0-9 \n.]+$");

          // RegExp regExp = new RegExp(pattern);
          if (value!.isEmpty) {
            return "Resturant Description cant be empty";
          }
          if (!regex.hasMatch(value!)) {
            return "Only letters and numbers are allowed!";
          }
          if (value!.length < 3) {
            return "Min input length is 3 characters.";
          }
          if (value!.length > 120) {
            return "Max input length is 120 characters.";
          } else
            return null;
        },
      ),
    );
  }

  Widget buildContainerOpenMap(
      {required TextEditingController textEditingController,
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

  Color mainColor() => const Color(0xFF5a3769);
}
