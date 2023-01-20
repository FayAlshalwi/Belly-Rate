import 'dart:async';
import 'dart:convert';
import 'package:belly_rate/auth/signin_page.dart';
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

  final periodicTimer = Timer.periodic(
    //
    const Duration(seconds: 60 * 12 * 14),
    (timer) {
      GetRecommendation();
      print('GetRecommendation timer');
    },
  );
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
      // final uri = Uri.parse('http://127.0.0.1:5000/ratings');
      // print("here2");
      // final response = await get(uri);
      // print("here3");
      // print(response.body);
      // print("here");
      // final decoded = json.decode(response.body) as Map<String, dynamic>;
      // print("here4");
      // print('Recommendation');
      // print(decoded['recommeneded'][0]);
      // print(decoded['recommeneded'][1]);
      // print(decoded['recommeneded'][2]);

      // print('history');
      // FirebaseFirestore.instance.collection('History').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': decoded['recommeneded'][0],
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });
      // FirebaseFirestore.instance.collection('History').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': decoded['recommeneded'][1],
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });

      // FirebaseFirestore.instance.collection('History').doc().set({
      //   'userId': FirebaseAuth.instance.currentUser!.uid,
      //   'RestaurantId': decoded['recommeneded'][2],
      //   'Notified': false,
      //   'Notified_location': false,
      //   "Date_Of_Recommendation": FieldValue.serverTimestamp(),
      // });
      // print('done history');

      // print("update Users");
      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .update({
      //   "rest": [
      //     decoded['recommeneded'][0],
      //     decoded['recommeneded'][1],
      //     decoded['recommeneded'][2]
      //   ],
      // });
      // print("Done Users");

      // final res = await FirebaseFirestore.instance
      //     .collection('Recommendation')
      //     .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();
      // print(res.docs[0].id);
      // print(res.docs[1].id);
      // print(res.docs[2].id);

      // await FirebaseFirestore.instance
      //     .collection('Recommendation')
      //     .doc(res.docs[0].id)
      //     .update({"RestaurantId": decoded['recommeneded'][0]});
      // await FirebaseFirestore.instance
      //     .collection('Recommendation')
      //     .doc(res.docs[1].id)
      //     .update({"RestaurantId": decoded['recommeneded'][1]});
      // await FirebaseFirestore.instance
      //     .collection('Recommendation')
      //     .doc(res.docs[2].id)
      //     .update({
      //   "RestaurantId": decoded['recommeneded'][2],
      // });
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
