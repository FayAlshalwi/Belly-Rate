import 'dart:async';
import 'dart:convert';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Notification.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

SharedPreferences? UserData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserData = await SharedPreferences.getInstance();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  signup();
  // final periodicTimer = Timer.periodic(
  //   //
  //   const Duration(seconds: 60 * 12 * 14),
  //   (timer) {
  //     GetRecommendation();
  //     print('GetRecommendation timer');
  //   },
  // );
  AwesomeNotifications().getGlobalBadgeCounter().then(
        (value) => AwesomeNotifications().setGlobalBadgeCounter(0),
      );
  // if (FirebaseAuth.instance.currentUser != null) {
  print("in");
  final periodicTimer2 = Timer.periodic(
    //
    //60 * 24 * 3
    const Duration(days: 3),
    (timer) async {
      // print("here1");
      // final uri =
      //     Uri.parse('https://bellyrate-urhmg.ondigitalocean.app/ratings');
      // print("here2");
      // final response = await get(
      //   uri,
      //   headers: <String, String>{
      //     'usrID': FirebaseAuth.instance.currentUser!.uid.toString(),
      //   },
      // );
      // print("here3");
      // print(response.body);
      // print("here");
      // var responseData = json.decode(response.body);
      // print(responseData[0].toString());
      // print(responseData[1].toString());
      // print(responseData[2].toString());
      // print("here4");

      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .update({
      //   "rest": [
      //     responseData[0].toString(),
      //     responseData[1].toString(),
      //     responseData[2].toString(),
      //   ],
      // });
      // print("user updated");
      // FirebaseFirestore.instance.collection('Recommendation').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': responseData[0].toString(),
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });

      // print("Recommendation 1 added");

      // FirebaseFirestore.instance.collection('Recommendation').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': responseData[1].toString(),
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });

      // print("Recommendation 2 added");

      // FirebaseFirestore.instance.collection('Recommendation').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': responseData[2].toString(),
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });

      // print("Recommendation 3 added");

      // FirebaseFirestore.instance.collection('History').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': responseData[0].toString(),
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });
      // print("History 1 added");
      // FirebaseFirestore.instance.collection('History').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': responseData[1].toString(),
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });
      // print("History 2 added");
      // FirebaseFirestore.instance.collection('History').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': responseData[2].toString(),
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });
      // print("History 3 added");
    },
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
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      user = FirebaseAuth.instance.currentUser!;
      print("currentUser: ${user?.uid}");
    } catch (e) {
      print("currentUser_Error: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: MyApp._title,
        home: user?.uid == null ? SignIn() : HomePage());
  }
}

void GetRecommendation() async {
  try {
    print('inside GetRecommendation');
    final _firestore = FirebaseFirestore.instance;
    final _firebaseAuth = FirebaseAuth.instance;
    final UID = FirebaseAuth.instance.currentUser!.uid;

    final res = await _firestore
        .collection('Recommendation')
        .where("userId", isEqualTo: UID)
        .where("Notified", isEqualTo: false)
        .get();

    if (res.docs.isNotEmpty) {
      print('recommendation is here');
// Get RestaurantId
      String RestaurantId = res.docs[0]['RestaurantId'];
      print('RestaurantId is = $RestaurantId');
      String docid = res.docs[0].id;
      print('docid is = $docid');
//set isNotified to true
      FirebaseFirestore.instance
          .collection('Recommendation')
          .doc(docid)
          .update({"Notified": true});

      ContentOfNotification(RestaurantId);
    } else {
      print('no recommendation!');
    }
  } catch (e) {
    print('User not loged in');
  }
} //GetRecommendation

Future<void> signup() async {
  // print("here1");
  // final uri = Uri.parse('https://bellyrate-urhmg.ondigitalocean.app/ratings');
  // // final uri = Uri.parse('http://127.0.0.1:5000/ratings');
  // print("here2");
  // final response = await get(
  //   uri,
  //   headers: <String, String>{
  //     'usrID': FirebaseAuth.instance.currentUser!.uid.toString(),
  //   },
  // );
  // print("here3");
  // print(response.body);
  // print("here");
  // var responseData = json.decode(response.body);
  // print(responseData[0].toString());
  // print(responseData[1].toString());
  // print(responseData[2].toString());
  // print("here4");

  // await FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .update({
  //   "rest": [
  //     responseData[0].toString(),
  //     responseData[1].toString(),
  //     responseData[2].toString(),
  //   ],
  // });
  // print("user updated");
  // FirebaseFirestore.instance.collection('Recommendation').doc().set({
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'RestaurantId': responseData[0].toString(),
  //   'Notified': false,
  //   'Notified_location': false,
  //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
  // });

  // print("Recommendation 1 added");

  // FirebaseFirestore.instance.collection('Recommendation').doc().set({
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'RestaurantId': responseData[1].toString(),
  //   'Notified': false,
  //   'Notified_location': false,
  //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
  // });

  // print("Recommendation 2 added");

  // FirebaseFirestore.instance.collection('Recommendation').doc().set({
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'RestaurantId': responseData[2].toString(),
  //   'Notified': false,
  //   'Notified_location': false,
  //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
  // });

  // print("Recommendation 3 added");

  // FirebaseFirestore.instance.collection('History').doc().set({
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'RestaurantId': responseData[0].toString(),
  //   'Notified': false,
  //   'Notified_location': false,
  //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
  // });
  // print("History 1 added");
  // FirebaseFirestore.instance.collection('History').doc().set({
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'RestaurantId': responseData[1].toString(),
  //   'Notified': false,
  //   'Notified_location': false,
  //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
  // });
  // print("History 2 added");
  // FirebaseFirestore.instance.collection('History').doc().set({
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'RestaurantId': responseData[2].toString(),
  //   'Notified': false,
  //   'Notified_location': false,
  //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
  // });
  // print("History 3 added");
}

void ContentOfNotification(String RestaurantId) async {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  String category = "";
  String name = "";
  String Photo = "";

  final res = await _firestore
      .collection('Restaurants')
      .where("ID", isEqualTo: RestaurantId)
      .get();

  if (res.docs.isNotEmpty) {
    String docid = res.docs[0].id;
    print(docid);

    // Get category, name, photo
    category = res.docs[0]['category'];
    print(category);
    print(category.toLowerCase());
    name = res.docs[0]['name'];
    print(name);

    List<dynamic> Recommendationphotos = [];

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
            "Fast and yummy, Good food for your belly!, lets go and try $name.";
        // NotificationContent = "Burgers! Because no great story started with salad. lets go and try $name.";
        print(NotificationContent);
        break;
      }

    case ('french restaurant'):
      {
        NotificationContent =
            "It's time to enjoy the finer things in life!, how about trying $name.";
        //  NotificationContent = "A genuine fine-dining experience awaits!, how about trying $name.";
        print(NotificationContent);
        break;
      }

    case ("health food restaurant"):
      {
        NotificationContent =
            "Choose healthy. Be strong. Live long!, Run to try $name.";
        //  NotificationContent = "We’re fresher! We’re tastier! We’re recommending $name!";
        print(NotificationContent);
        break;
      }

    case ("indian restaurant"):
      {
        NotificationContent =
            "We suggest something hut, somthing tasty!, go and taste $name.";
        //NotificationContent = "Spice it up!, and try $name.";
        print(NotificationContent);
        break;
      }

    case ("italian restaurant"):
      {
        NotificationContent =
            "Delicious Italian food, just the way it should be!, $name is a must.";
        print(NotificationContent);
        break;
      }

    case ("japanese restaurant"):
      {
        NotificationContent =
            "Roll with us, and go to try $name. where sushi lovers rejoice!";
        print(NotificationContent);
        break;
      }

    case ("lebanese restaurant"):
      {
        NotificationContent =
            "Celebrating the pure, simple pleasures of Authentic lebanese cuisine!, lets go and try $name.";
        print(NotificationContent);
        break;
      }

    case ("seafood restaurant"):
      {
        NotificationContent =
            "Try $name, and Keep The Waves of Seafood Coming!";
        // Fresh From The Net, You Won’t Regret!
        print(NotificationContent);
        break;
      }
    default:
      print('DEFAULT case');
      NotificationContent =
          "New recommendation match your test!, lets go to try $name.";
      print(NotificationContent);
  } //switch

  createNotification(NotificationContent, RestaurantId, Photo, name);
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
