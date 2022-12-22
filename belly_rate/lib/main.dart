import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';
import 'Notification.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'Storing_DB.dart';


void main() async {

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
            ledColor: Colors.white
        )
    ]
);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  

  final periodicTimer = Timer.periodic(
  const Duration(seconds: 10),
  (timer) {
     print('Update user about remaining time');
     //GetRecommendation();
     ContentOfNotification('134992');

  },
);

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Belly Rate';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   iconTheme: IconThemeData(color: Color(0xff7b39ed)),
      //   inputDecorationTheme: InputDecorationTheme(
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(10),
      //         borderSide: BorderSide(color: Colors.grey.shade400),
      //       ),
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(10),
      //       )),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //         minimumSize: Size(double.infinity, 50),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8),
      //         )),
      //   ),
      //   textTheme: TextTheme(
      //       headline4:
      //           TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //       subtitle1: TextStyle(
      //         color: Color.fromARGB(255, 0, 0, 0),
      //       )),
      //   appBarTheme: AppBarTheme(
      //       backgroundColor: Colors.transparent,
      //       elevation: 0,
      //       iconTheme: IconThemeData(color: Colors.black)),
      //   primaryColor: Color(0xff7b39ed),
      //   primarySwatch: primarySwatch,
      // ),
      home: HomePage(),
    );
  }
}


void GetRecommendation() async{
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

}//GetRecommendation 

void ContentOfNotification( String RestaurantId )async{
  print(1);
  final _firestore = FirebaseFirestore.instance;
  //final _firebaseAuth = FirebaseAuth.instance;
  //final UID = FirebaseAuth.instance.currentUser!.uid
  final UID = '';
  String category="";
  String name ="";
  String Photo=""; 

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
          }else{
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
switch(category.toLowerCase() ){
  
  case ("american restaurant") :{
    NotificationContent = "It seems that you like American restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

  case ('french restaurant'):{
    NotificationContent = "It seems that you like French restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

  case("health food restaurant"):{
    NotificationContent = "It seems that you like Health food restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

  case("indian restaurant"):{
    NotificationContent = "It seems that you like Indian restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

  case("italian restaurant"):{
    NotificationContent = "It seems that you like Italian restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

  case("japanese restaurant"):{
    NotificationContent = "It seems that you like Japanese restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

   case("lebanese restaurant"):{
    NotificationContent = "It seems that you like Lebanese restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }

   case("seafood restaurant"):{
     NotificationContent = "It seems that you like Seafood restaurant!, how about trying $name.";
    print(NotificationContent); 
    break;
  }
}//switch 

//createPlantFoodNotification(NotificationContent , Photo);
NotificationContent = "hhh";
  createPlantFoodNotification(NotificationContent , RestaurantId);

}


