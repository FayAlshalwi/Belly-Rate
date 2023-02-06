import 'dart:convert';
import 'package:belly_rate/category_parts/category_slider_homepage.dart';
import 'package:belly_rate/category_parts/nearYou.dart';
import 'package:belly_rate/favoritePage.dart';
import 'package:belly_rate/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:belly_rate/models/restaurantModesl.dart';
import 'package:belly_rate/models/userModel.dart';
import 'package:belly_rate/myProfile.dart';
import 'package:belly_rate/views/carousel_loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'category_parts/category_slider.dart';
import 'category_parts/restaurantDetails.dart';
import 'category_parts/restaurant_model.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'Notification.dart';
import 'main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  get restaurantDetails => null;
  void initState() {
    super.initState();
    userlocation();

    Future.delayed(Duration.zero, () async {
      Position position = await _determinePosition();
      if (position != null) {
        print("dddd ${position.latitude}");
        UserData!.setDouble('locationLat', position.latitude);
        UserData!.setDouble('locationLon', position.longitude);
      }
    });

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

    AwesomeNotifications().actionStream.listen((notification) async {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }

      String? resID = notification.summary;
      print(resID);

      List<Restaurant> restaurantsDetailss = [];

      final _firestore = FirebaseFirestore.instance;
      final _firebaseAuth = FirebaseAuth.instance;

      final restt = await FirebaseFirestore.instance
          .collection('Restaurants')
          .where('ID', isEqualTo: resID)
          .get();

      String category = restt.docs[0]['category'];

      for (var item in restt.docs) {
        final restaurant = Restaurant.fromJson(item.data());

        Restaurant restaurantDetails = Restaurant(
            phoneNumber: restaurant.phoneNumber,
            category: restaurant.category,
            description: restaurant.description,
            location: restaurant.location,
            name: restaurant.name,
            photos: restaurant.photos,
            priceAvg: restaurant.priceAvg,
            id: restaurant.id);

        setState(() {
          restaurantsDetailss.add(restaurantDetails);
        });
      }

      Navigator.pushAndRemoveUntil(
        this.context,
        MaterialPageRoute(
            builder: (Context) => RestaurantDetails(
                restaurant: restaurantsDetailss[0],
                category_name: restaurantsDetailss[0].category.toString())),
        (route) => route.isFirst,
      );
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
  List<Restaurant> restaurantsDetailss = [];
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

      for (var item in restt.docs) {
        final restaurant = Restaurant.fromJson(item.data());

        Restaurant restaurantDetails = Restaurant(
            phoneNumber: restaurant.phoneNumber,
            category: restaurant.category,
            description: restaurant.description,
            location: restaurant.location,
            name: restaurant.name,
            photos: restaurant.photos,
            priceAvg: restaurant.priceAvg,
            id: restaurant.id);
        print("res name");
        print(restaurantDetails.name);
        setState(() {
          restaurantsDetailss.add(restaurantDetails);
        });
      }

      setState(() {
        restaurants.add(restaurant);
        restaurantsImgs.add(restaurant.photos[0]);
      });
    }
  }

  Future<Position> _determinePosition() async {
    print('inside _determinePosition');
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

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
    location.onLocationChanged.listen((LocationData currentLocation) async {
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
          String RestaurantId =
              Recommendation.docs[i]['RestaurantId'].toString();
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
        }
      } else {
        print('no recommendation for this user!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayOfWidth = MediaQuery.of(context).size.width;
    var x = 0;
    var y = 0;
    var z = 0;

    final List<Widget> imageSliders = restaurantsImgs
        .map((item) => Container(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      print("GestureDetector");
                      print(item);
                      for (int i = 0; 0 < restaurantsImgs.length; i++)
                        if (item == restaurantsImgs[i])
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => RestaurantDetails(
                                      category_name: restaurantsDetailss[i]
                                          .category
                                          .toString(),
                                      restaurant: restaurantsDetailss[i],
                                    )),
                          );
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(item,
                                fit: BoxFit.cover, width: 1000.0),
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
                                ))
                          ],
                        )),
                  )),
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
          SizedBox(
            height: 4,
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
            height: 4,
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
          RestaurantSlider(),
          SizedBox(
            height: 4,
          ),
        ],
      )),
      //Favorite page container
      Container(child: Favorite()),
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
          margin: EdgeInsets.all(displayOfWidth * .03),
          height: displayOfWidth * .144,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
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

void ContentOfLocationNotification(String RestaurantId) async {
  print('inside ContentOfLocationNotification');
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
        print('Photo not empty');
      } else {
        print('Photo empty');
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
            // "Fast and yummy, Good food for your belly!, lets go and try $name.";
            // NotificationContent = "Burgers! Because no great story started with salad. lets go and try $name.";
            NotificationContent =
                "Look like you're near $name restaurant! let's go and give it a try.";
        print(NotificationContent);
        break;
      }

    case ('french restaurant'):
      {
        // NotificationContent ="It's time to enjoy the finer things in life!, how about trying $name.";
        //  NotificationContent = "A genuine fine-dining experience awaits!, how about trying $name.";
        NotificationContent =
            "$name restaurant is a few steps away! what about trying it out!";
        print(NotificationContent);
        break;
      }

    case ("health food restaurant"):
      {
        // NotificationContent =
        //   "Choose healthy. Be strong. Live long!, Run to try $name.";
        //  NotificationContent = "We’re fresher! We’re tastier! We’re recommending $name!";
        NotificationContent =
            "Look like you're near $name restaurant! let's go and give it a try.";
        print(NotificationContent);
        break;
      }

    case ("indian restaurant"):
      {
        // NotificationContent =
        //   "We suggest something hut, somthing tasty!, go and taste $name.";
        NotificationContent =
            "Spice it up! You're near $name, go and give it a try!";
        print(NotificationContent);
        break;
      }

    case ("italian restaurant"):
      {
        // NotificationContent =
        //   "Delicious Italian food, just the way it should be!, $name is a must.";
        NotificationContent =
            "Margarita is calling, you're near $name restaurant, let's give it a try";
        print(NotificationContent);
        break;
      }

    case ("japanese restaurant"):
      {
        //NotificationContent =
        //  "Roll with us, and go to try $name. where sushi lovers rejoice!";
        NotificationContent =
            "Look like you're near $name restaurant! let's go and give it a try.";
        print(NotificationContent);
        break;
      }

    case ("lebanese restaurant"):
      {
        // NotificationContent =
        //   "Celebrating the pure, simple pleasures of Authentic lebanese cuisine.!, try $name.";
        NotificationContent =
            "Smelling olive oils? you're near $name restaurant, let's give it a try!.";
        print(NotificationContent);
        break;
      }

    case ("seafood restaurant"):
      {
        //NotificationContent =
        //  "Try $name, and Keep The Waves of Seafood Coming!";
        // Fresh From The Net, You Won’t Regret!
        NotificationContent =
            "Look like you're near $name restaurant! let's go and give it a try.";
        print(NotificationContent);
        break;
      }
    default:
      print('DEFAULT case');
      NotificationContent =
          "Look like you're near $name restaurant! let's go and give it a try.";
      print(NotificationContent);
  } //switch

  createNotification(NotificationContent, RestaurantId, Photo, name);
}
