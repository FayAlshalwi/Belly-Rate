import 'dart:convert';
import 'dart:developer';
import 'package:belly_rate/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:belly_rate/models/restaurantModesl.dart';
import 'package:belly_rate/models/user.dart';
import 'package:belly_rate/myProfile.dart';
import 'package:belly_rate/views/carousel_loading.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../Notification.dart';
import '../category_parts/category_slider.dart';
import '../category_parts/category_slider_homepage.dart';
import '../favoritePage.dart';
import '../main.dart';

import 'package:provider/provider.dart';

import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'addRestaurants.dart';
import 'contactUsManger.dart';
import 'myProfileManger.dart';

class HomePageManger extends StatefulWidget {
  HomePageManger({Key? key}) : super(key: key);

  _HomePageManger createState() => _HomePageManger();
}

class _HomePageManger extends State<HomePageManger> {
  void initState() {
    super.initState();
  }

  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double displayOfWidth = MediaQuery.of(context).size.width;
    var x = 0;
    List<Widget> listOfWidgets = [
      //Add Restaurants container
      Container(child: AddRestaurants()),
      //Contact Us Manger container
      Container(child: ContactUsManger()),
      //Profile page Manger container
      Container(child: MyProfileManger()),
    ];
    List<IconData> listOfIcons = [
      Icons.home_rounded,
      Icons.list,
      Icons.person_rounded,
    ];

    List<String> listOfStrings = [
      'Home',
      'Requests',
      'Profile',
    ];

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
              itemCount: 3,
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
                            ? displayOfWidth * .40
                            : displayOfWidth * .25,
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
}
