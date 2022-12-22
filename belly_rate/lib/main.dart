import 'package:belly_rate/HomePage.dart';
import 'package:belly_rate/models/restaurantModesl.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:belly_rate/models/restaurantModesl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: null,
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
    );
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

void GetRecommendation() async {
  final _firestore = FirebaseFirestore.instance;
  //final _firebaseAuth = FirebaseAuth.instance;
  //final UID = FirebaseAuth.instance.currentUser!.uid
  final UID = '';

  //List<dynamic> RecommendationsList = [];

  final res = await _firestore
      .collection('Recommendation')
      .where("UserID", isEqualTo: UID)
      .where("isNotified", isEqualTo: false)
      .get();

  if (res.docs.isNotEmpty) {
// Get RestaurantId
    String RestaurantId = res.docs[0]['RestaurantId'];

//set isNotified to true
    /*FirebaseFirestore.instance.collection('Recommendation')
   .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({"isNotified": true });*/

    ContentOfNotification(RestaurantId);
  }
} //GetRecommendation

void ContentOfNotification(String RestaurantId) async {
  print(1);
  final _firestore = FirebaseFirestore.instance;
  //final _firebaseAuth = FirebaseAuth.instance;
  //final UID = FirebaseAuth.instance.currentUser!.uid
  final UID = '';
  String category = "";
  String name = "";
  String Photo = "";

  final res = await _firestore
      .collection('Restaurants')
      .where("ID", isEqualTo: RestaurantId)
      .get();
  print(2);
  if (res.docs.isNotEmpty) {
    print(3);
    // Get category, name, photo
    category = res.docs[0]['category'];
    print(category);
    name = res.docs[0]['name'];
    print(name);

    List<dynamic> Recommendationphotos = [];
    /*Recommendationphotos = res.docs[0]['photos'];
         if (Recommendationphotos.length != 0) {
          print('not empty');}*/

    try {
      Recommendationphotos = res.docs[0]['photos'];
      if (Recommendationphotos.length != 0) {
        Photo = Recommendationphotos[0];
        print('not empty');
      } else {
        print(' empty');
      }
    } catch (e) {
      Photo = "";
    }
    print(Photo);
  }
  print('last');

  String NotificationContent = "";
// NotificationContent

  switch (category.toLowerCase()) {
    case ("american restaurant"):
      {
        NotificationContent =
            "It seems that you like American restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ('french restaurant'):
      {
        NotificationContent =
            "It seems that you like French restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("health food restaurant"):
      {
        NotificationContent =
            "It seems that you like Health food restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("indian restaurant"):
      {
        NotificationContent =
            "It seems that you like Indian restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("italian restaurant"):
      {
        NotificationContent =
            "It seems that you like Italian restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("japanese restaurant"):
      {
        NotificationContent =
            "It seems that you like Japanese restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("lebanese restaurant"):
      {
        NotificationContent =
            "It seems that you like Lebanese restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("seafood restaurant"):
      {
        NotificationContent =
            "It seems that you like Seafood restaurant!, how about trying $name.";
        print(NotificationContent);
        break;
      }
  } //switch
}
