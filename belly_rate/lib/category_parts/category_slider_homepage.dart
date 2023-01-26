import 'dart:developer';
import 'package:belly_rate/category_parts/restaurantDetails.dart';
import 'package:belly_rate/category_parts/restaurant_model.dart';
import 'package:belly_rate/category_parts/restaurants_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../main.dart';
import 'category_model.dart';

class RestaurantSlider extends StatefulWidget {
  const RestaurantSlider({Key? key}) : super(key: key);

  @override
  State<RestaurantSlider> createState() => _RestaurantSliderState();
}

class _RestaurantSliderState extends State<RestaurantSlider> {
  // List<Restaurant> _restaurant = [];
  // // List<Restaurant> _restaurantBurger = [] ;S
  // List<Restaurant> _restaurantAmericanRestaurant = [];
  // List<Restaurant> _restaurantSeafoodRestaurant = [];
  // List<Restaurant> _restaurantIndianRestaurant = [];
  // List<Restaurant> _restaurantItalianRestaurant = [];
  // List<Restaurant> _restaurantJapaneseRestaurant = [];
  // List<Restaurant> _restaurantOtherRestaurant = [];
  // List<Restaurant> _restauranthealthRestaurant = [];
  // List<Restaurant> _restaurantlebaneseRestaurant = [];
  // // List<Restaurant> _restaurantFastRestaurant = [] ;

  List<Restaurant> _restaurant = [];
  var Kilometer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    final restaurants =
        await FirebaseFirestore.instance.collection('Restaurants').get();
    // List<Restaurant> restaurant_list_temp = [] ;
    for (var Category in restaurants.docs) {
      Restaurant restaurant = Restaurant.fromJson(Category.data());

      // Kilometer = distance(
      //     LatLng((UserData?.getDouble('locationLat'))!,(UserData?.getDouble('locationLon'))!),
      //     LatLng(double.parse("${restaurant.lat}"), double.parse("${restaurant.long}")
      //     ));
      // restaurant.far = double.parse((Kilometer/1000).toStringAsFixed(2)) ;
      var ffff = Geolocator.distanceBetween(
          (UserData?.getDouble('locationLat'))!,
          (UserData?.getDouble('locationLon'))!,
          double.parse("${restaurant.lat}"),
          double.parse("${restaurant.long}"));
      // print("distance: ${(ffff / 1000).toStringAsFixed(2)} KM");
      // print("ffff ${ffff}");
      restaurant.far = double.parse((ffff / 1000).toStringAsFixed(2));
      _restaurant.add(restaurant);
    }

    _restaurant.sort((a, b) => a.far!.compareTo(b.far!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color txt_color = Color(0xFF5a3769);
    return Container(
      height: heightM * 10,
      child: ListView.builder(
        itemCount: 10,
        // itemCount: _restaurant.length,
        scrollDirection: Axis.vertical,
        // scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (_restaurant.isNotEmpty) {
            Restaurant item = _restaurant[index];
            print(item.location);
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
              child: InkWell(
                onTap: () {
                  /// RestaurantDetails
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => RestaurantDetails(
                              category_name: item.category!,
                              restaurant: item,
                            )),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          child: Image.network("${item.photos?.first}",
                              height: heightM * 7,
                              width: heightM * 15,
                              fit: BoxFit.fill)),
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
                            Text("${getBuildPriceAvg(item)}",
                                style: ourTextStyle(
                                    txt_color: Colors.black,
                                    txt_size: heightM * 0.5)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 8.0, top: 3.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Far From you: ${item.far ?? ""} KM",
                                    style: ourTextStyle(
                                        txt_color: Colors.grey,
                                        txt_size: heightM * 0.5)),
                              ],
                            ),
                            InkWell(
                                onTap: () async {
                                  // MapsLauncher.launchCoordinates(
                                  //     double.parse(item.lat!),
                                  //     double.parse(item.long!));
                                },
                                child: const Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF5a3769),
                                  size: 30,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  Widget buildContainerList(Color txt_color, double heightM, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        width: 120,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  (_restaurant[index].photos?.first)!,
                  height: 50,
                  width: 50,
                ),
                Text(_restaurant[index].name!,
                    style: ourTextStyle(
                        txt_color: txt_color, txt_size: heightM * 0.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? getBuildPriceAvg(Restaurant item) {
    if (item.priceAvg?.toLowerCase().trim() == "High".toLowerCase().trim()) {
      return "\$\$\$";
    } else if (item.priceAvg?.toLowerCase().trim() ==
        "Medium".toLowerCase().trim()) {
      return "\$\$";
    } else if (item.priceAvg?.toLowerCase().trim() ==
        "Low".toLowerCase().trim()) {
      return "\$";
    } else {
      return "";
    }
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
      color: txt_color,
      fontWeight: FontWeight.bold,
      fontSize: txt_size,
    );
  }

  List<Category> categoryList = [
    Category(name: "Italian", icon: "asset/category_img/italian.png"),
    Category(name: "seafood", icon: "asset/category_img/seafood.png"),
    Category(name: "Health food", icon: "asset/category_img/healthFood.png"),
    Category(name: "Indian", icon: "asset/category_img/indian.png"),
    Category(name: "American", icon: "asset/category_img/American.png"),
    Category(name: "Lebanese", icon: "asset/category_img/Lebanese.png"),
    Category(name: "Japanese", icon: "asset/category_img/Japanese.png"),
    Category(name: "Other", icon: "asset/category_img/other.png"),
  ];
}
