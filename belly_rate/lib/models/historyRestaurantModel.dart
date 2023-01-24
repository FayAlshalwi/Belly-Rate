import 'dart:convert';

import 'package:belly_rate/models/rateModel.dart';

import '../category_parts/restaurant_model.dart';

HistoryRestaurant historyRestaurantFromJson(String str) =>
    HistoryRestaurant.fromJson(json.decode(str));

String historyRestaurantToJson(HistoryRestaurant data) =>
    json.encode(data.toJson());

class HistoryRestaurant {
  HistoryRestaurant({
    this.dateOfRecommendation,
    this.recommendationId,
    this.userId,
    this.notified,
    this.restaurantId,
    this.restaurant,
    this.notifiedLocation,
    this.rate,
  });

  String? dateOfRecommendation;
  String? recommendationId;
  String? restaurantId;
  Restaurant? restaurant;
  Rate? rate;
  String? userId;
  bool? notified;
  bool? notifiedLocation;

  factory HistoryRestaurant.fromJson(Map<String, dynamic> json) =>
      HistoryRestaurant(
        dateOfRecommendation: json["Date_Of_Recommendation"].toString(),
        recommendationId: json["RecommendationID"],
        restaurantId: json["RestaurantId"],
        userId: json["userId"],
        notified: json["Notified"],
        restaurant: json["restaurant"],
        rate: json["rate"],
        notifiedLocation: json["Notified_location"],
      );

  Map<String, dynamic> toJson() => {
        "Date_Of_Recommendation": dateOfRecommendation,
        "restaurant": restaurant,
        "RecommendationID": recommendationId,
        "RestaurantId": restaurantId,
        "userId": userId,
        "Notified": notified,
        "rate": rate,
        "Notified_location": notifiedLocation,
      };
}
