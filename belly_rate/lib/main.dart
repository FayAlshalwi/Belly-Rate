import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth/signin_page.dart';
import 'auth/welcome_page.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'Storing_DB.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Belly Rate';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      user = FirebaseAuth.instance.currentUser! ;
      print("currentUser: ${user?.uid}");
    } catch(e){
      print("currentUser_Error: ${e}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyApp._title,
      home: user?.uid == null ? SignIn() : WelcomePage()

      // Scaffold(
      //   appBar: AppBar(title: const Text(_title)),
      //   body: const SignIn(),
      //   // body: const MyStatefulWidget(),
      // ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController IDController = TextEditingController();
  TextEditingController catController = TextEditingController();
  File? image;
  File? image2;
  File? image3;
  File? image4;

  //pickImage func
  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
    return imageTemp;
  }

  Future pickImage2(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image2 = imageTemp);
    return imageTemp;
  }

  Future pickImage3(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image3 = imageTemp);
    return imageTemp;
  }

  Future pickImage4(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image4 = imageTemp);
    return imageTemp;
  }

// dialoge to choose image
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: const Text('Create a Recommendation'),
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

  _selectImage2(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: const Text('Create a Recommendation'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () {
                  pickImage2(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () {
                  pickImage2(ImageSource.gallery);
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

  _selectImage3(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: const Text('Create a Recommendation'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () {
                  pickImage3(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () {
                  pickImage3(ImageSource.gallery);
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

  _selectImage4(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: const Text('Create a Recommendation'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () {
                  pickImage4(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () {
                  pickImage4(ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: IDController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: catController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price Average',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  _selectImage(context);
                }, // Image tapped

                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    image == null
                        ? Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.network(
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
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
                            height: 60,
                            width: 60,
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
            GestureDetector(
                onTap: () {
                  _selectImage2(context);
                }, // Image tapped

                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    image2 == null
                        ? Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.network(
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
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
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.file(image2!, fit: BoxFit.cover),
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
            GestureDetector(
                onTap: () {
                  _selectImage3(context);
                }, // Image tapped

                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    image3 == null
                        ? Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.network(
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
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
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.file(image3!, fit: BoxFit.cover),
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
            GestureDetector(
                onTap: () {
                  _selectImage4(context);
                }, // Image tapped

                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    image4 == null
                        ? Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.network(
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
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
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(400), // Image radius
                                child: Image.file(image4!, fit: BoxFit.cover),
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
            SizedBox(
              height: 10,
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text(
                    'Add',
                  ),
                  onPressed: () async {
                    print(nameController.text);
                    print(descriptionController.text);
                    print(locationController.text);
                    print(phoneNumberController.text);
                    print(priceController.text);

                    addData(
                        IDController.text,
                        image!,
                        image2!,
                        image3!,
                        image4!,
                        nameController.text,
                        catController.text,
                        descriptionController.text,
                        locationController.text,
                        phoneNumberController.text,
                        priceController.text);
                    // await FirebaseFirestore.instance
                    //     .collection('Restaurants')
                    //     .doc(nameController.text)
                    //     .set({
                    //   'photo1': '',
                    //   'name': nameController.text,
                    //   'description': descriptionController.text,
                    //   'location': locationController.text,
                    //   'phoneNumber': phoneNumberController.text,
                    //   'priceAvg': priceController.text,
                    // }).onError((e, _) => print("Error writing document: $e"));
                    // addPhoto(image!, nameController.text);
                    IDController.clear();
                    nameController.clear();
                    descriptionController.clear();
                    locationController.clear();
                    phoneNumberController.clear();
                    priceController.clear();
                    showAlertDialog(context);
                  },
                )),
          ],
        ));
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Added"),
    content: Text("Restaurant added successfully"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
