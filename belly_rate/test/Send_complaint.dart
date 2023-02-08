// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:belly_rate/main.dart';

// void main() {

//   group('send complain', () { 

//     test("empty complain title ", () {
//      //setup
//      String title = "";
//      //do
//     String actual =  send_complaint_title(title);
//     //test
//     expect(actual, "Please enter complaint title");
//     });

//        test("complain title with special characters", () {
//      //setup
//      String title = "";
//      //do
//     String actual =  send_complaint_title(title);
//     //test
//     expect(actual, "You cannot enter special characters !@#\%^&*()");
//     });


//   test("empty description form", () {
//      //setup
//      String description = "";
//      //do
//     String actual =  send_complaint_desc(description);
//     //test
//     expect(actual, "Please enter complain description");
//     });

//       test("Description with special characters", () {
//      //setup
//      String description = "Hello#";
//      //do
//     String actual =  send_complaint_desc(description);
//     //test
//     expect(actual, "You cannot enter special characters !@#\%^&*()");
//     });

//     test("Description with less than 3 characters", () {
//      //setup
//      String description = "Hi";
//      //do
//     String actual =  send_complaint_desc(description);
//     //test
//     expect(actual, "Please enter at least 3 characters");
//     });

//         test("Valid Description", () {
//      //setup
//      String description = "Hello, i need help to update my name.";
//      //do
//     String actual =  send_complaint_desc(description);
//     //test
//     expect(actual, "Success");
//     });
//   });
// }