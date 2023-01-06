// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

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
  });

  String? priceAvg;
  String? phoneNumber;
  String? name;
  String? description;
  String? location;
  String? id;
  double? far;
  String? lat ;
  String? long ;
  String? category;
  List<String>? photos;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    priceAvg: json["priceAvg"] == null ? null : json["priceAvg"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    location: json["location"] == null ? null : json["location"],
    id: json["ID"] == null ? null : json["ID"],
    far: json["far"],
    lat: json["lat"] == null ? null : json["lat"],
    long: json["long"] == null ? null : json["long"],
    category: json["category"] == null ? null : json["category"],
    photos: json["photos"] == null ? null : List<String>.from(json["photos"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "priceAvg": priceAvg == null ? null : priceAvg,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "location": location == null ? null : location,
    "ID": id == null ? null : id,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "category": category == null ? null : category,
    "far": far,
    "photos": photos == null ? null : List<dynamic>.from(photos!.map((x) => x)),
  };
}
