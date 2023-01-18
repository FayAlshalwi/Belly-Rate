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
import 'category_parts/category_slider.dart';
import 'category_parts/restaurant_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'Notification.dart';
import 'utilities.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  void initState() {
    super.initState();
    print('dalal');

    /////LOCATION Tracking
    userlocation();
//Nouf
    _determinePosition();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: this.context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              'Allow Notifications',
              style: TextStyle(
                color: const Color(0xFF5a3769),
              ),
            ),
            content: Text('Belly Rate would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF5a3769),
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
                      fontSize: 15,
                      color: const Color(0xFF5a3769),
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
    });

    get();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  var currentIndex = 0;

  static late UserInfoModel user;
  static List<restaurantModel> restaurants = [];
  static List<String> restaurantsImgs = [];

  get() async {
    final res = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    print(FirebaseAuth.instance.currentUser!.uid);
    print("info");
    print(res.docs[0]['uid']);
    print(res.docs[0]['phoneNumber']);
    print(res.docs[0]['name']);
    print(res.docs[0]['picture']);
    print(res.docs[0]['rest']);
    user = UserInfoModel(
        uid: res.docs[0]['uid'],
        phoneNumber: res.docs[0]['phoneNumber'],
        name: res.docs[0]['name'],
        photo: res.docs[0]['picture'],
        recommendedRestaurant: res.docs[0]['rest']);

    for (int i = 0; i < user.recommendedRestaurant.length; i++) {
      final restt = await FirebaseFirestore.instance
          .collection('Restaurants')
          .where('ID', isEqualTo: user.recommendedRestaurant[i])
          .get();

      restaurantModel restaurant = restaurantModel(
          phoneNumber: restt.docs[0]['phoneNumber'],
          category: restt.docs[0]['category'],
          description: restt.docs[0]['description'],
          location: restt.docs[0]['location'],
          name: restt.docs[0]['name'],
          photos: restt.docs[0]['photos'],
          priceAvg: restt.docs[0]['priceAvg'],
          resId: restt.docs[0]['ID']);
      setState(() {
        restaurants.add(restaurant);
        restaurantsImgs.add(restaurant.photos[0]);
      });
    }
  }

  //Nouf

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    print('inside _determinePosition');
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    } else {
      print('Location services are enabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      } else {
        print('Location permissions are not denied!!');
      }
    } else {
      print('Location permissions are not denied!!');
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /////Location
  userlocation() async {
    print('inside userlocation method');

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      location.enableBackgroundMode(enable: true);
      if (_permissionGranted != PermissionStatus.granted) {
        return LocationData;
      }
    }

/*Future<void> distanceInMeters(String RestaurantId ,double userlat , double userlong , String RecommendationDocID) async {

  print('inside distanceInMeters method');

  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;


  final Restaurants = await _firestore
      .collection('Restaurants')
      .where("ID", isEqualTo: RestaurantId)
      .get();

      if (Restaurants.docs.isNotEmpty) {
     double  RLongitude = double.parse(Restaurants.docs[0]['long']);
     double RLatitude = double.parse(Restaurants.docs[0]['lat']);

    double distanceInMeters = Geolocator.distanceBetween(RLatitude , RLongitude , userlat , userlong);

    if(distanceInMeters <= 2000){
      print('$distanceInMeters');
      print('less than 2km');

       print('docid is = $RecommendationDocID');
        FirebaseFirestore.instance
        .collection('Recommendation')
        .doc(RecommendationDocID)
        .update({"Notified_location": true});

        ContentOfLocationNotification(RestaurantId);
    }
    else{
       print('$distanceInMeters');
      print('More than 2km');
    }
      }// if isNotEmpty 

}//distanceInMeters*/

    location.onLocationChanged.listen((LocationData currentLocation) async {
      // Use current location
      print('onLocationChanged method');
      print('currentLocation.latitude:');
      print(currentLocation.latitude);
      print('currentLocation.longitude');
      print(currentLocation.longitude);

      final _firestore = FirebaseFirestore.instance;
      final _firebaseAuth = FirebaseAuth.instance;
      final UID = FirebaseAuth.instance.currentUser!.uid;

      final Recommendation = await _firestore
          .collection('Recommendation')
          .where("userId", isEqualTo: UID)
          .where("Notified_location", isEqualTo: false)
          .get();

      if (Recommendation.docs.isNotEmpty) {
        for (int i = 0; i < Recommendation.docs.length; i++) {
          String RestaurantId = Recommendation.docs[i]['RestaurantId'];
          double? userlat = currentLocation.latitude;
          double? userlong = currentLocation.longitude;
          String RecommendationDocID = Recommendation.docs[i].id;

          final Restaurants = await _firestore
              .collection('Restaurants')
              .where("ID", isEqualTo: RestaurantId)
              .get();

          if (Restaurants.docs.isNotEmpty) {
            double Restaurantlong = double.parse(Restaurants.docs[0]['long']);
            double Restaurantlat = double.parse(Restaurants.docs[0]['lat']);

            double distanceInMeters = Geolocator.distanceBetween(
                Restaurantlat, Restaurantlong, userlat!, userlong!);

            if (distanceInMeters <= 2000) {
              print('$distanceInMeters');
              print('less or equal than 2km');

              print('docid is = $RecommendationDocID');
              FirebaseFirestore.instance
                  .collection('Recommendation')
                  .doc(RecommendationDocID)
                  .update({"Notified_location": true});

              ContentOfLocationNotification(RestaurantId);
            } else {
              print('$distanceInMeters');
              print('More than 2km');
            }
          }
          //distanceInMeters(RestaurantId ,lat! , long! , RecommendationDocID );
        }
      } else {
        print('no recommendation for this user!');
      }
    });
  } //userlocation

  @override
  Widget build(BuildContext context) {
    double displayOfWidth = MediaQuery.of(context).size.width;
    var x = 0;
    final List<Widget> imageSliders = restaurantsImgs
        .map((item) => Container(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                              restaurants[x++].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    List<Widget> listOfWidgets = [
      //home page container
      Container(
          child: Column(
        children: [
          SizedBox(
            height: 55,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Recommended Restaurants",
                  style: TextStyle(
                      color: Color(0xFF5a3769),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Saudi Arabia, Riyadh",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          (restaurants.isEmpty == true)
              ? CarouselLoading()
              : Container(
                  child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    autoPlay: true,
                  ),
                  items: imageSliders,
                )),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Discover Restaurants",
                  style: TextStyle(
                      color: Color(0xFF5a3769),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              )),
          CategorySlider(),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Near you",
                  style: TextStyle(
                      color: Color(0xFF5a3769),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ],
      )),
      //Favorite page container
      Container(child: Text('Favorite')),
      //History page container
      Container(child: history()),
      //Profile page container
      Container(child: myProfile()),
    ];
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
}
