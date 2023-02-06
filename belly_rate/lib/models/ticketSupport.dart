// To parse this JSON data, do
//
//     final ticketSupport = ticketSupportFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

TicketSupport ticketSupportFromJson(String str) => TicketSupport.fromJson(json.decode(str));

String ticketSupportToJson(TicketSupport data) => json.encode(data.toJson());

class TicketSupport {
  TicketSupport({
    this.uid,
    this.requestText,
    this.username,
    this.requestDateTime,
    this.answerDateTime,
    this.requestAnswer,
    this.requestId,
    this.status,
    this.requestTitle,
  });

  String? uid;
  String? requestText;
  String? requestAnswer;
  String? requestTitle;
  String? username;
  Timestamp? requestDateTime;
  Timestamp? answerDateTime;
  String? requestId;
  String? status;

  factory TicketSupport.fromJson(Map<String, dynamic> json) => TicketSupport(
    uid: json["UID"],
    requestText: json["request_text"],
    requestTitle: json["request_title"],
    requestDateTime: json["request_date_time"] ?? "",
    requestAnswer: json["request_answer"] ?? "",
    username: json["user_name"] ?? "",
    answerDateTime: json["answer_date_time"] ?? "",
    requestId: json["request_id"],
    status: json["status"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "UID": uid,
    "request_title": requestTitle,
    "request_text": requestText,
    "request_answer": requestAnswer,
    "answer_date_time": answerDateTime,
    "user_name": username,
    "request_date_time": requestDateTime,
    "request_id": requestId,
    "status": status,
  };
}
