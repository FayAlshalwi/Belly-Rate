// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

import '../models/rateModel.dart';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  Restaurant({
    this.priceAvg,
    this.phoneNumber,
    this.name,
    this.description,
    this.location,
    this.id,
    this.long,
    this.lat,
    this.category,
    this.photos,
    this.far,
    this.rateAVG,
    this.rate,
    this.rateAVGNum,
  });

  String? priceAvg;
  String? phoneNumber;
  String? rateAVG;
  String? rateAVGNum;
  String? name;
  String? description;
  String? location;
  String? id;
  double? far;
  String? lat ;
  String? long ;
  Rate? rate;
  String? category;
  List<String>? photos;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    priceAvg: json["priceAvg"] == null ? null : json["priceAvg"],
    rateAVGNum: json["rateAVGNum"] == null ? null : json["rateAVGNum"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    rateAVG: json["rateAVG"] == null ? null : json["rateAVG"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    location: json["location"] == null ? null : json["location"],
    id: json["ID"] == null ? null : json["ID"],
    far: json["far"],
    lat: json["lat"] == null ? null : json["lat"],
    long: json["long"] == null ? null : json["long"],

    rate: json["rate"],
    category: json["category"] == null ? null : json["category"],
    photos: json["photos"] == null ? null : List<String>.from(json["photos"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "priceAvg": priceAvg == null ? null : priceAvg,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "name": name == null ? null : name,
    "rateAVG": rateAVG == null ? null : rateAVG,
    "description": description == null ? null : description,
    "location": location == null ? null : location,
    "ID": id == null ? null : id,
    "rateAVGNum": rateAVGNum == null ? null : rateAVGNum,
    "rate": rate,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "category": category == null ? null : category,
    "far": far,
    "photos": photos == null ? null : List<dynamic>.from(photos!.map((x) => x)),
  };
}