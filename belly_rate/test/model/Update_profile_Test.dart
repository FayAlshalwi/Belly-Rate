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
     String name = "";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "Please enter your name");

    });

     test("Name less than 3 characters", () {

     //setup
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
    expect(actual, "You cannot enter number and special characters !@#\%^&*()");
    });

    test("name with special characters", () {

     //setup
     String name = "@Dalal";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "You cannot enter number and special characters !@#\%^&*()");
    });

    test("Valid name", () {

     //setup
     String name = "Dalal";
     //do
    String actual =  UpdateName(name);
    //test
    expect(actual, "Profile updated successfully!");
    });

    test("Valid photo", () {

     //setup
     String img = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png" ;
     //do
    String actual =  updatephoto(img);
    //test
    expect(actual, "Profile updated successfully!");
    });

    test("Valid photo and name", () {

     //setup
     String img = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png" ;
     String name = "Dalal";
     //do
    String actual =  updatephoto(img );
    String actualname =  UpdateName(name);
    //test
    expect(actual, "Profile updated successfully!");
    expect(actualname, "Profile updated successfully!");
    });


  });
  
}
