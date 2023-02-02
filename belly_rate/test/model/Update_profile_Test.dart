import 'package:belly_rate/myProfile.dart';
import 'package:belly_rate/updateProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belly_rate/main.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('Update Profile', () { 

    test("null name", () {

     //setup
     UpdateProfile updateProfile = UpdateProfile(); 
     String name = "";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "Please enter your name");

    });

     test("Name less than 3 characters", () {

     //setup
     UpdateProfile updateProfile = UpdateProfile(); 
     String name = "da";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "Please enter at least 3 characters");

    });

    test("name with number", () {

     //setup
     UpdateProfile updateProfile = UpdateProfile(); 
     String name = "67Dalal";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "You cannot enter special characters !@#\%^&*()");

    });

    test("name with special characters", () {

     //setup
     UpdateProfile updateProfile = UpdateProfile(); 
     String name = "6@7Dalal";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "You cannot enter special characters !@#\%^&*()");

    });

    test("Valid name", () {

     //setup
     UpdateProfile updateProfile = UpdateProfile(); 
     String name = "Dalal";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "Success");
    });
  });
  
}
