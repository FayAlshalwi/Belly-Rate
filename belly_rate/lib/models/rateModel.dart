// To parse this JSON data, do
//
//     final rate = rateFromJson(jsonString);

import 'dart:convert';

Rate rateFromJson(String str) => Rate.fromJson(json.decode(str));

String rateToJson(Rate data) => json.encode(data.toJson());

class Rate {
  Rate({
    this.uid,
    this.rate,
    this.rateId,
    this.restId,
  });

  String? uid;
  String? rate;
  String? rateId;
  String? restId;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
    uid: json["UID"],
    rate: json["rate"],
    rateId: json["rateID"],
    restId: json["restID"],
  );

  Map<String, dynamic> toJson() => {
    "UID": uid,
    "rate": rate,
    "rateID": rateId,
    "restID": restId,
  };
}
