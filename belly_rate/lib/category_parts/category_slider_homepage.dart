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
    for (var Category in restaurants.docs) {
      Restaurant restaurant = Restaurant.fromJson(Category.data());

      var ffff = Geolocator.distanceBetween(
          (UserData?.getDouble('locationLat'))!,
          (UserData?.getDouble('locationLon'))!,
          double.parse("${restaurant.lat}"),
          double.parse("${restaurant.long}"));

      restaurant.far = double.parse((ffff / 1000).toStringAsFixed(2));
      _restaurant.add(restaurant);
    }

    _restaurant.sort((a, b) => a.far!.compareTo(b.far!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double heightM = 30;
    Color txt_color = Color(0xFF5a3769);
    return Container(
      // color: Color.fromARGB(255, 255, 255, 255),
      width: 410,
      height: 280,
      child: Scrollbar(
          thickness: 3.0,
          radius: const Radius.circular(20),
          child: ListView.builder(
              padding: EdgeInsets.fromLTRB(2, 5, 2, 0),
              reverse: false,
              itemCount: 3,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                if (_restaurant.isNotEmpty) {
                  Restaurant item = _restaurant[index];
                  // print(item.location);
                  return InkWell(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // InkWell(
                          //     onTap: () {
                          //       Navigator.of(context).push(
                          //         MaterialPageRoute(
                          //             builder: (context) => RestaurantDetails(
                          //                   category_name: item.category!,
                          //                   restaurant: item,
                          //                 )),
                          //       );
                          //     },
                          //     child:
                          Container(
                            height: 90,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0, bottom: 0.0, top: 0.0, right: 0.0),
                              child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(2, 2, 9, 2),
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            "${item.photos?.first}",
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            padding: EdgeInsets.only(
                                                left: 0.0,
                                                bottom: 0.0,
                                                top: 0.0,
                                                right: 0.0),
                                            child: Text("${item.name}",
                                                style: ourTextStyle(
                                                    txt_color: txt_color,
                                                    txt_size: heightM * 0.6))),
                                        Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Text("${item.category}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color.fromARGB(
                                                      255, 63, 63, 63),
                                                  fontWeight: FontWeight.w500,
                                                )

                                                // ourTextStyle(
                                                //     txt_color: Color.fromARGB(
                                                //         255, 116, 116, 116),
                                                //     txt_size: heightM * 0.45, )

                                                )),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),

                          // ),
                          // InkWell(
                          //     onTap: () {
                          //       Navigator.of(context).push(
                          //         MaterialPageRoute(
                          //             builder: (context) => RestaurantDetails(
                          //                   category_name: item.category!,
                          //                   restaurant: item,
                          //                 )),
                          //       );
                          //     },
                          // child:
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 27,
                                  width: item.far!.floor() < 10
                                      ? 85
                                      : item.far!.floor() > 10
                                          ? 95
                                          : 107,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(244, 216, 107, 147),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                      child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 1, 0),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      Text("${item.far!.toStringAsFixed(2)} KM",
                                          textAlign: TextAlign.center,
                                          style: ourTextStyle(
                                              txt_color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              txt_size: heightM * 0.43))
                                    ],
                                  )),
                                )
                              ])
                          // )
                        ],
                      ));
                } else
                  return Container();
              })),
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
