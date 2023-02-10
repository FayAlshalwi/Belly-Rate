import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_parts/restaurantDetails.dart';
import 'category_parts/restaurant_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'main.dart';
import 'models/rateModel.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_btn/loading_btn.dart';

class Favorite extends StatefulWidget {
  Favorite({Key? key}) : super(key: key);

  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  User? user;
  List<Restaurant> FavoriteList = [];
  bool isWrong = false;
  double? ratee = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    print("currentUser: ${user?.uid}");

    Future.delayed(Duration.zero).then((value) async {
      getFavorite();
    });

    Future.delayed(Duration.zero, () async {
      Position position = await _determinePosition();
      if (position != null) {
        print("dddd ${position.latitude}");
        UserData!.setDouble('locationLat', position.latitude);
        UserData!.setDouble('locationLon', position.longitude);
      }
    });
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
          "Favorite Restaurants",
          style: TextStyle(
            fontSize: 22,
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: getBody(heightM),
    );
  }

  Widget getBody(double heightM) {
    // return FavoriteList.length != 0 && !isWrong ?
    if (FavoriteList.length != 0) {
      return ListView.builder(
        itemCount: FavoriteList.length,
        itemBuilder: (BuildContext context, int index) {
          Restaurant item = FavoriteList[index];
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => RestaurantDetails(
                                    category_name: item.category!,
                                    restaurant: item,
                                  )),
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 0, top: 0, right: 0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Image.network("${item.photos?.first}",
                                    height: heightM * 2.5,
                                    width: heightM * 2.5,
                                    fit: BoxFit.fill),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                bottom: 15.0,
                                top: 15.0,
                                right: 19.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, right: 19.0),
                                    child: Text("${item.name}",
                                        style: ourTextStyle(
                                            txt_color: Color(0xFF5a3769),
                                            txt_size: heightM * 0.6))),
                                if (item.rate != null)
                                  Positioned(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0,
                                              bottom: 0.0,
                                              top: 0.0,
                                              right: 16.0),
                                          child: item.rate!.rate == "0.5"
                                              ? StarWidget5()
                                              : item.rate!.rate == "1.5"
                                                  ? StarWidget15()
                                                  : item.rate!.rate == "2.5"
                                                      ? StarWidget25()
                                                      : item.rate!.rate == "3.5"
                                                          ? StarWidget35()
                                                          : item.rate!.rate ==
                                                                  "4.5"
                                                              ? StarWidget45()
                                                              : StarWidget(
                                                                  activated: double.tryParse(item
                                                                          .rate!
                                                                          .rate
                                                                          .toString())!
                                                                      .toDouble(),
                                                                )))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (item.rate != null)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, bottom: 3.0, top: 3.0, right: 22.0),
                      child: Icon(Icons.favorite_outline_rounded,
                          size: 28, color: Color.fromARGB(255, 216, 107, 147)),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } else if (FavoriteList.length == 0 && isWrong) {
      return Center(
          child: Column(
        children: [
          SizedBox(
            height: 160,
          ),
          Image.asset(
            'asset/category_img/noFav1.png',
            height: 230,
          ),
          Text("No Favorites",
              style: TextStyle(
                fontSize: 22,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w600,
              )),
          Padding(
            padding: EdgeInsets.only(
                left: 19.0, bottom: 15.0, top: 0.0, right: 19.0),
            child: Text(
                "You can add restaurants to your favorites by rating it with more than four stars",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 63, 63, 63),
                  fontWeight: FontWeight.w500,
                )),
          )
        ],
      ));
    } else {
      return Center(
        child: LoadingAnimationWidget.discreteCircle(
            size: 35,
            color: Color(0xFF5a3769),
            secondRingColor: Colors.grey.shade700,
            thirdRingColor: Color.fromARGB(255, 216, 107, 147)),
      );
    }
  }

  void getFavorite() async {
    final _firestore = FirebaseFirestore.instance;
    final _firebaseAuth = FirebaseAuth.instance;
    final UID = FirebaseAuth.instance.currentUser!.uid;

    final res = await _firestore
        .collection('rating')
        .where("UID", isEqualTo: UID)
        .get();
    List<Restaurant> FavoriteListBase = [];
    final restaurants =
        await FirebaseFirestore.instance.collection('Restaurants').get();

    for (var rest in restaurants.docs) {
      final resta = Restaurant.fromJson(rest.data());
      var ffff = Geolocator.distanceBetween(
          (UserData?.getDouble('locationLat'))!,
          (UserData?.getDouble('locationLon'))!,
          double.parse("${resta.lat}"),
          double.parse("${resta.long}"));
      resta.far = double.parse((ffff / 1000).toStringAsFixed(2));

      FavoriteListBase.add(resta);
    }

    if (res.docs.isNotEmpty) {
      FavoriteList.clear();
      List<Rate> rates = [];
      for (var item in res.docs) {
        final rate = Rate.fromJson(item.data()) as Rate;
        rates.add(rate);
      }

      print("-----");
      rates.sort((a, b) => a.rate!.compareTo(b.rate!));
      rates = rates.reversed.toList();
      rates.forEach((element) {
        print(element.toJson());
      });

      rates.removeWhere((element) => double.parse(element.rate!) <= 3);
      print("${rates.length} __");
      addResttoList(rates, FavoriteListBase);
      if (rates.isNotEmpty) {
        isWrong = false;
      } else {
        isWrong = true;
      }
      setState(() {});
    } else {
      print('no getFavorite!');
      isWrong = true;
      setState(() {});
    }
  }

  void addResttoList(List<Rate> rates, List<Restaurant> FavoriteListBase) {
    if (rates.length >= 5) {
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[0].restId.toString()));
      FavoriteList.last.rate = rates[0];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[1].restId.toString()));
      FavoriteList.last.rate = rates[1];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[2].restId.toString()));
      FavoriteList.last.rate = rates[2];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[3].restId.toString()));
      FavoriteList.last.rate = rates[3];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[4].restId.toString()));
      FavoriteList.last.rate = rates[4];
    } else if (rates.length == 4) {
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[0].restId.toString()));
      FavoriteList.last.rate = rates[0];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[1].restId.toString()));
      FavoriteList.last.rate = rates[1];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[2].restId.toString()));
      FavoriteList.last.rate = rates[2];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[3].restId.toString()));
      FavoriteList.last.rate = rates[3];
    } else if (rates.length == 3) {
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[0].restId.toString()));
      FavoriteList.last.rate = rates[0];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[1].restId.toString()));
      FavoriteList.last.rate = rates[1];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[2].restId.toString()));
      FavoriteList.last.rate = rates[2];
    } else if (rates.length == 2) {
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[0].restId.toString()));
      FavoriteList.last.rate = rates[0];
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[1].restId.toString()));
      FavoriteList.last.rate = rates[1];
    } else if (rates.length == 1) {
      FavoriteList.add(FavoriteListBase.firstWhere(
          (element) => element.id.toString() == rates[0].restId.toString()));
      FavoriteList.last.rate = rates[0];
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
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    } else {
      print('Location services are enabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else {
        print('Location permissions are not denied!!');
      }
    } else {
      print('Location permissions are not denied!!');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
