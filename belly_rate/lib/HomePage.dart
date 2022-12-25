import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_parts/category_slider.dart';
import 'category_parts/restaurant_model.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'Storing_DB.dart';
import 'Notification.dart';
import 'utilities.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: this.context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Belly Rate would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    
    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }

      String? resID = notification.summary;
      print(resID);

      /*Navigator.pushAndRemoveUntil(
        this.context,
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
        (route) => route.isFirst,
      );*/
    }
    );

    
    }

     @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double displayOfWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(child: listOfWidgets[currentIndex]),
      bottomNavigationBar: Container(
          margin: EdgeInsets.all(displayOfWidth * .05),
          height: displayOfWidth * .155,
          decoration: BoxDecoration(
              color: Colors.white70,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.07),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50)),
          child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: displayOfWidth * .02),
              itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                        HapticFeedback.lightImpact();
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        width: index == currentIndex
                            ? displayOfWidth * .32
                            : displayOfWidth * .18,
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height:
                              index == currentIndex ? displayOfWidth * .12 : 0,
                          width:
                              index == currentIndex ? displayOfWidth * .32 : 0,
                          decoration: BoxDecoration(
                            color: index == currentIndex
                                ? Color(0xFFae96e82).withOpacity(.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        width: index == currentIndex
                            ? displayOfWidth * .31
                            : displayOfWidth * .18,
                        alignment: Alignment.center,
                        child: Stack(children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == currentIndex
                                    ? displayOfWidth * .13
                                    : 0,
                              ),
                              AnimatedOpacity(
                                opacity: index == currentIndex ? 1 : 0,
                                duration: Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Text(
                                  index == currentIndex
                                      ? '${listOfStrings[index]}'
                                      : '',
                                  style: TextStyle(
                                    color: Color(0xFFae96e82),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == currentIndex
                                    ? displayOfWidth * .03
                                    : 20,
                              ),
                              Icon(
                                listOfIcons[index],
                                size: displayOfWidth * .076,
                                color: index == currentIndex
                                    ? Color(0xFFae96e82)
                                    : Colors.black26,
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ]),
                  ))),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.history_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Favorite',
    'History',
    'Profile',
  ];

  List<Widget> listOfWidgets = [
    //home page container
    Container(
        child: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Recommended Restaurants",
            style: TextStyle(
                color: Color(0xFF5a3769),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Saudi Arabia, Riyadh",
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 270,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Discover Restaurants",
            style: TextStyle(
                color: Color(0xFF5a3769),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        CategorySlider(),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Near you",
            style: TextStyle(
                color: Color(0xFF5a3769),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
       /*  TextButton (
  onPressed: () => {
    print('Dalal'),
	//do something
  createPlantFoodNotification('It seems that you like American restaurant!, how about trying KFC.' , '134992'),
  print('Dalal')
  },
  child: new Text('Click me'),
),*/
       
      ],
    )),
    //Favorite page container
    Container(child: Text('Favorite')),
    //History page container
    Container(child: Text('History')),
    //Profile page container
    Container(child: Text('Profile')),
  ];
}
