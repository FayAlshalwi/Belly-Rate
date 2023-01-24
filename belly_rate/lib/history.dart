import 'dart:convert';
import 'dart:developer';
import 'package:belly_rate/auth/our_user_model.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:belly_rate/auth/signup_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:belly_rate/auth/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// To parse this JSON data, do
//
//     final restaurantsList = restaurantsListFromJson(jsonString);

import 'dart:convert';

import 'category_parts/restaurant_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'main.dart';
import 'models/historyRestaurantModel.dart';
import 'models/rateModel.dart';

import 'package:intl/intl.dart';

class history extends StatefulWidget {
  history({Key? key}) : super(key: key);

  _history createState() => _history();
}

class _history extends State<history> {
  User? user;
  List<HistoryRestaurant> historyList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    print("currentUser: ${user?.uid}");

    Future.delayed(Duration.zero).then((value) async {
      getHistory();
      // var vari = await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(user!.uid)
      //     .get();
      // print("currentUser: ${vari.data()}");
      // setState(() {});
    });

    Future.delayed(Duration.zero, () async {
      Position position = await _determinePosition();
      if (position != null) {
        print("dddd ${position.latitude}");
        UserData!.setDouble('locationLat', position.latitude);
        UserData!.setDouble('locationLon', position.longitude);
      }
    });

    // User? user =  FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color txt_color = Color(0xFF5a3769);
    final Color button_color = Color.fromARGB(255, 216, 107, 147);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Restaurant History",
          style: TextStyle(
            fontSize: 22,
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (BuildContext context, int index) {
          HistoryRestaurant item = historyList[index];
          print("fdsfsd " + item.dateOfRecommendation!);

          // Timestamp timestamp = item.dateOfRecommendation as Timestamp;
          num seconds = int.parse(item.dateOfRecommendation!.substring(
              item.dateOfRecommendation!.indexOf("=") + 1,
              item.dateOfRecommendation!.indexOf(",")));
          num nanoseconds = int.parse(item.dateOfRecommendation!.substring(
              item.dateOfRecommendation!.lastIndexOf("=") + 1,
              item.dateOfRecommendation!.indexOf(")")));

          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              ((seconds * 1000).toInt()) + (nanoseconds ~/ 1000000));

          // DateTime convertedDateTime = DateTime.parse(item.dateOfRecommendation.toString());
          // Timestamp timestamp = Timestamp.fromDate(convertedDateTime);
          // DateTime dateTime = timestamp.toDate();
          // // dateTimeUpdate = dateTime;
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          // DateTime.fromMicrosecondsSinceEpoch((item.dateOfRecommendation)).toString();

          // print(item.location);
          return Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        buildShowRestaurantDetails(
                            context, item.restaurant!, heightM, txt_color);
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.network(
                                "${item.restaurant?.photos?.first}",
                                height: heightM * 2.5,
                                width: heightM * 2.5,
                                fit: BoxFit.fill),
                          ),

                          ///
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item.restaurant?.name}",
                                    style: ourTextStyle(
                                        txt_color: Color(0xFF5a3769),
                                        txt_size: heightM * 0.6)),
                                Text("Date: ${formattedDate}",
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: ourTextStyle(
                                        txt_color: Colors.grey.shade700,
                                        txt_size: heightM * 0.4)),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text("${item.restaurant?.description}",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: ourTextStyle(
                                          txt_color: Colors.grey,
                                          txt_size: heightM * 0.4)),
                                ),
                                if (item.rate != null)
                                  Text("Rate: ${item.rate!.rate} / 5.0",
                                      style: ourTextStyle(
                                          txt_color: Colors.pinkAccent,
                                          txt_size: heightM * 0.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///
                  if (item.rate == null)
                    InkWell(
                      onTap: () {
                        print("qqq");
                        String rating = "";

                        showModalBottomSheet<dynamic>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            //change the height of the bottom sheet
                            height: MediaQuery.of(context).size.height * 0.22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            //content of the bottom sheet
                            child: Column(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                const SizedBox(
                                  height: 50,
                                  child: Text(
                                    "Rate & Review",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5a3769)),
                                  ),
                                ),
                                RatingBar.builder(
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  glowColor: Color(0xFF5a3769),
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {
                                    rating = value.toString();
                                    print(rating);
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Material(
                                    elevation: 10.0,
                                    borderRadius:
                                        BorderRadius.circular(5.0), //12
                                    color: Colors
                                        .transparent, //Colors.cyan.withOpacity(0.5),
                                    child: MaterialButton(
                                      minWidth: 15,
                                      color: button_color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      splashColor: button_color,
                                      onPressed: () async {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.loading,
                                          text: "Loading",
                                        );

                                        bool isRate = await addRate(
                                                rate: rating.toString(),
                                                restID: item.restaurantId!)
                                            .then((value) {
                                          setState(() {
                                            historyList.clear();
                                          });
                                          getHistory();
                                          return true;
                                        });

                                        if (isRate) {
                                          print("isRate");
                                          CoolAlert.show(
                                            title: "Success",
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Rate added successfully!",
                                            confirmBtnColor: Color.fromARGB(
                                                255, 216, 107, 147),
                                            onConfirmBtnTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        } else {
                                          print("No isRate");
                                          Navigator.of(context).pop();
                                        }
                                        // Navigator.of(context).pop();
                                      },
                                      child: Text('Submit',
                                          textAlign: TextAlign.center,
                                          style: ourTextStyle(
                                              txt_color: Colors.white,
                                              txt_size: heightM * 0.6)),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                        child:
                            Icon(Icons.star_border, color: Colors.pinkAccent),
                      ),
                    ),

                  if (item.rate != null)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                      child: Icon(Icons.star, color: Colors.pinkAccent),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildShowRestaurantDetails(
      BuildContext context, Restaurant item, double heightM, txt_color) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              // bottomLeft: Radius.circular(15.0),
              // bottomRight: Radius.circular(15.0),
            ),
          ),
          // title: Text("Alert Dialog"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(height: heightM * 5.0),
                      items: item.photos?.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: txt_color.withOpacity(0.5)),
                                child: CachedNetworkImage(
                                    imageUrl: "${i}",
                                    // child: Image.network("${i}",
                                    height: heightM * 5,
                                    width: heightM * 15,
                                    fit: BoxFit.fill));
                          },
                        );
                      }).toList(),
                    )
                    // Image.network("${item.photos?.first}",
                    //     height: heightM * 5,
                    //     width: heightM * 15,
                    //     fit: BoxFit.fill)
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.name}",
                        style: ourTextStyle(
                            txt_color: Color(0xFF5a3769),
                            txt_size: heightM * 0.7)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                child: Text("${item.description}",
                    style: ourTextStyle(
                        txt_color: Colors.grey, txt_size: heightM * 0.5)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 8.0, top: 3.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              // item.phoneNumber == "No phone number"
                              //     ? print("no phone")
                              //     : launchPhoneDialer(item.phoneNumber!);
                            },
                            child: Icon(
                              Icons.call,
                              color: Color(0xFF5a3769),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${item.phoneNumber}",
                            style: ourTextStyle(
                                txt_color: Colors.grey,
                                txt_size: heightM * 0.5)),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () async {
                              // _launchUrl(item.location!);
                              // openMap(double.parse(item.lat!) , double.parse(item.long!));
                              // MapsLauncher.launchCoordinates(
                              //     double.parse(item.lat!),
                              //     double.parse(item.long!));
                            },
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF5a3769),
                              size: 30,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${item.far} KM",
                            style: ourTextStyle(
                                txt_color: Colors.grey,
                                txt_size: heightM * 0.5)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> addRate({required String rate, required String restID}) async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore.collection("rating").add({
      'rateID': '',
      'UID': '${user?.uid}',
      'rate': rate,
      'restID': restID,
      // Add more fields as needed
    }).then((value) async {
      await _firestore
          .collection("rating")
          .doc(value.id)
          .update({"rateID": value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  void getHistory() async {
    // try{

    print('inside getHistory');
    final _firestore = FirebaseFirestore.instance;
    final _firebaseAuth = FirebaseAuth.instance;
    final UID = FirebaseAuth.instance.currentUser!.uid;

    final res = await _firestore
        .collection('History')
        .where("userId", isEqualTo: UID)
        .where("Notified", isEqualTo: false)
        .get();

    if (res.docs.isNotEmpty) {
      historyList.clear();
      for (var item in res.docs) {
        // final body = json.encode(Category.data().toString());
        // log("Res: ${body}");
        // final restaurant = restaurantFromJson(Category.data().toString());
        HistoryRestaurant temp;
        final restaurant = HistoryRestaurant.fromJson(item.data());
        temp = restaurant;

        final rateRes = await FirebaseFirestore.instance
            .collection('rating')
            .where("UID", isEqualTo: UID)
            .where("restID", isEqualTo: temp.restaurantId)
            .get();

        for (var Category in rateRes.docs) {
          final rate = Rate.fromJson(Category.data()) as Rate;
          temp.rate = rate;
        }

        final res = await FirebaseFirestore.instance
            .collection('Restaurants')
            .where("ID", isEqualTo: restaurant.restaurantId)
            .get();

        // log("Res: ${res}");
        if (res != null && res.size > 0) {
          // final tempRestaurant = Restaurant.fromJson(res.docs.first.data()) as Restaurant;
          for (var Category in res.docs) {
            final restaurant =
                Restaurant.fromJson(Category.data()) as Restaurant;

            var ffff = Geolocator.distanceBetween(
                (UserData?.getDouble('locationLat'))!,
                (UserData?.getDouble('locationLon'))!,
                double.parse("${restaurant.lat}"),
                double.parse("${restaurant.long}"));
            // print("distance: ${(ffff / 1000).toStringAsFixed(2)} KM");
            // print("ffff ${ffff}");
            restaurant.far = double.parse((ffff / 1000).toStringAsFixed(2));

            temp.restaurant = restaurant;
          }
          // log("Res: ${tempRestaurant}");
          // temp.restaurant = tempRestaurant;
        }
        historyList.add(restaurant);
      }
      setState(() {});
    } else {
      print('no getHistory!');
    }
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
      color: txt_color,
      fontWeight: FontWeight.bold,
      fontSize: txt_size,
    );
  }

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
}


// import 'dart:convert';
// import 'package:belly_rate/auth/our_user_model.dart';
// import 'package:belly_rate/auth/signin_page.dart';
// import 'package:belly_rate/auth/signup_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:belly_rate/auth/signin_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class history extends StatefulWidget {
//   history({Key? key}) : super(key: key);

//   _history createState() => _history();
// }

// class _history extends State<history> {
//   User? user;
//   OurUser? ourUser;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     user = FirebaseAuth.instance.currentUser!;
//     print("currentUser: ${user?.uid}");

//     Future.delayed(Duration.zero).then((value) async {
//       var vari = await FirebaseFirestore.instance
//           .collection("Users")
//           .doc(user!.uid)
//           .get();
//       // Map<String,dynamic> userData = vari as Map<String,dynamic>;
//       print("currentUser: ${vari.data()}");

//       // ourUser = OurUser(
//       //   first_name: vari.data()!['firstName'],
//       //   last_name: vari.data()!['lastName'],
//       //   phone_number: vari.data()!['phoneNumber'],
//       // );
//       setState(() {});
//     });

//     // User? user =  FirebaseAuth.instance.currentUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         centerTitle: true,
//         title: const Text(
//           "My Profile",
//           style: TextStyle(
//             fontSize: 22,
//             color: const Color(0xFF5a3769),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("Welcome "),
//             Text("Name :  ${ourUser?.name}"),
//             Text("Mobile Number :  ${ourUser?.phone_number}"),
//             ElevatedButton(
//                 onPressed: () async {
//                   print("here1");
//                   final uri = Uri.parse('http://127.0.0.1:5000/ratings');
//                   print("here2");

//                   final response = await get(uri);
//                   print("here3");
//                   print(response.body);
//                   print("here");

//                   final decoded =
//                       json.decode(response.body) as Map<String, dynamic>;
//                   print("here4");

//                   print(decoded['recommeneded']);
//                 },
//                 child: Text("print")),
//             ElevatedButton(
//                 onPressed: () async {
//                   final url = 'http://127.0.0.1:5000/';
//                   final uri = Uri.parse('http://127.0.0.1:5000/ratings');
//                   final response = await post(uri,
//                       body: json.encode({
//                         'rating': ["U22", "ty", 8, 5, 9]
//                       }));
//                 },
//                 child: Text("Add Rate")),
//             ElevatedButton(
//                 onPressed: () async {
//                   final uri = Uri.parse('http://127.0.0.1:5000/recommendation');
//                   final response = await post(uri,
//                       body: json.encode(
//                           {'usrID': FirebaseAuth.instance.currentUser!.uid}));
//                   final decoded =
//                       json.decode(response.body) as Map<String, dynamic>;
//                   print("here4");

//                   print(decoded['recommeneded']);
//                 },
//                 child: Text("recommend")),
//           ],
//         ),
//       ),
//     );
//   }
// }
