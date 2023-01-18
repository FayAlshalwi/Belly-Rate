import 'dart:async';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
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
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
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
    const Duration(seconds: 60 * 5),
    (timer) {
      GetRecommendation();
      print('GetRecommendation timer');
    },
  );
  AwesomeNotifications().getGlobalBadgeCounter().then(
        (value) => AwesomeNotifications().setGlobalBadgeCounter(0),
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
        home: user?.uid == null ? SignIn() : HomePage()

        // Scaffold(
        //   appBar: AppBar(title: const Text(_title)),
        //   body: const SignIn(),
        //   // body: const MyStatefulWidget(),
        // ),
        );
  }
}

void GetRecommendation() async {
  try {
    print('inside GetRecommendation');
    final _firestore = FirebaseFirestore.instance;
    final _firebaseAuth = FirebaseAuth.instance;
    final UID = FirebaseAuth.instance.currentUser!.uid;
    // final UID = '111';

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
  print(1);
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  String category = "";
  String name = "";
  String Photo = "";

  final res = await _firestore
      .collection('Restaurants')
      .where("ID", isEqualTo: RestaurantId)
      .get();
  print(2);
  if (res.docs.isNotEmpty) {
    String docid = res.docs[0].id;
    print(docid);
    print(3);

    // Get category, name, photo
    category = res.docs[0]['category'];
    print(category);
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
            "Celebrating the pure, simple pleasures of Authentic lebanese cuisine.!, try  $name.";
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
  } //switch

//createPlantFoodNotification(NotificationContent ,RestaurantId, Photo);
  // createPlantFoodNotification(NotificationContent, RestaurantId);
  createNotification(NotificationContent, RestaurantId, Photo, name);
}
