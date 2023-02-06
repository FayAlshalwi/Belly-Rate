import 'dart:developer';

import 'package:belly_rate/category_parts/restaurant_model.dart';
import 'package:belly_rate/category_parts/restaurants_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/rateModel.dart';
import 'category_model.dart';

class CategorySlider extends StatefulWidget {
  const CategorySlider({Key? key}) : super(key: key);

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  List<Restaurant> _restaurant = [];
  // List<Restaurant> _restaurantBurger = [] ;
  List<Restaurant> _restaurantAmericanRestaurant = [];
  List<Restaurant> _restaurantSeafoodRestaurant = [];
  List<Restaurant> _restaurantIndianRestaurant = [];
  List<Restaurant> _restaurantItalianRestaurant = [];
  List<Restaurant> _restaurantJapaneseRestaurant = [];
  List<Restaurant> _restaurantOtherRestaurant = [];
  List<Restaurant> _restauranthealthRestaurant = [];
  List<Restaurant> _restaurantlebaneseRestaurant = [];
  // List<Restaurant> _restaurantFastRestaurant = [] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    final Categorys =
        await FirebaseFirestore.instance.collection('Restaurants').get();

    for (var Category in Categorys.docs) {
      final restaurant = Restaurant.fromJson(Category.data()) as Restaurant;

      _restaurant.add(restaurant);

      if (restaurant.category?.toLowerCase().trim() ==
          "american restaurant".toLowerCase())
        _restaurantAmericanRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "Seafood Restaurant".toLowerCase())
        _restaurantSeafoodRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "Indian restaurant".toLowerCase())
        _restaurantIndianRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "Italian restaurant".toLowerCase())
        _restaurantItalianRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "Japanese restaurant".toLowerCase())
        _restaurantJapaneseRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "health food restaurant".toLowerCase())
        _restauranthealthRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "lebanese restaurant".toLowerCase())
        _restaurantlebaneseRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "Asian restaurant".toLowerCase())
        _restaurantOtherRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "French Restaurant".toLowerCase())
        _restaurantOtherRestaurant.add(restaurant);
      else if (restaurant.category?.toLowerCase().trim() ==
          "Swiss restaurant".toLowerCase())
        _restaurantOtherRestaurant.add(restaurant);
      else {
        print(restaurant.category?.toLowerCase());
        _restaurantOtherRestaurant.add(restaurant);
      }
    }
    log("Res: ${_restaurant.length}");

    log("Res_American: ${_restaurantAmericanRestaurant.length}");
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color txt_color = Color(0xFF5a3769);
    return Container(
      height: 120,
      child: Scrollbar(
        thickness: 5.0,
        radius: const Radius.circular(20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildContainerList(txt_color, heightM, index);
          },
        ),
      ),
    );
  }

  Widget buildContainerList(Color txt_color, double heightM, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 111,
        child: Container(
          child: InkWell(
            onTap: () {
              print("${categoryList[index].name}");
              List<Restaurant> selected_list = [];
              String selected_category = "";

              if (categoryList[index].name.toLowerCase().trim() ==
                  "American".toLowerCase()) {
                print("${_restaurantAmericanRestaurant.length}");
                selected_list = _restaurantAmericanRestaurant;
                selected_category = "American Restaurant";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "Seafood".toLowerCase()) {
                print("${_restaurantSeafoodRestaurant.length}");
                selected_list = _restaurantSeafoodRestaurant;
                selected_category = "Seafood";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "Indian".toLowerCase()) {
                print("${_restaurantIndianRestaurant.length}");
                selected_list = _restaurantIndianRestaurant;
                selected_category = "Indian Restaurant";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "Italian".toLowerCase()) {
                print("${_restaurantItalianRestaurant.length}");
                selected_list = _restaurantItalianRestaurant;
                selected_category = "Italian Restaurant";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "Japanese".toLowerCase()) {
                print("${_restaurantJapaneseRestaurant.length}");
                selected_list = _restaurantJapaneseRestaurant;
                selected_category = "Japanese Restaurant";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "health food".toLowerCase()) {
                print("${_restauranthealthRestaurant.length}");
                selected_list = _restauranthealthRestaurant;
                selected_category = "Health Food Restaurant";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "lebanese".toLowerCase()) {
                print("${_restaurantlebaneseRestaurant.length}");
                selected_list = _restaurantlebaneseRestaurant;
                selected_category = "Lebanese Restaurant";
              } else if (categoryList[index].name.toLowerCase().trim() ==
                  "French".toLowerCase()) {
                print("${_restaurantOtherRestaurant.length}");
                selected_list = _restaurantOtherRestaurant;
                selected_category = "French Restaurant";
              }

              /// RestaurantsPage
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantsPage(
                            category_name: selected_category,
                            restaurant_list: selected_list,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    categoryList[index].icon,
                    height: 50,
                    width: 50,
                  ),
                  Text(categoryList[index].name,
                      style: ourTextStyle(
                          txt_color: txt_color, txt_size: heightM * 0.6)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
      color: txt_color,
      fontWeight: FontWeight.bold,
      fontSize: txt_size,
    );
  }

  List<Category> categoryList = [
    Category(name: "American", icon: "asset/category_img/American.png"),
    Category(name: "French", icon: "asset/category_img/other.png"),
    Category(name: "Health food", icon: "asset/category_img/healthFood.png"),
    Category(name: "Indian", icon: "asset/category_img/indian.png"),
    Category(name: "Italian", icon: "asset/category_img/italian.png"),
    Category(name: "Japanese", icon: "asset/category_img/Japanese.png"),
    Category(name: "Lebanese", icon: "asset/category_img/Lebanese.png"),
    Category(name: "Seafood", icon: "asset/category_img/seafood.png"),
  ];
}
