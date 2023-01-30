import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:belly_rate/category_parts/restaurantDetails.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import '../main.dart';
import '../models/rateModel.dart';
import 'restaurant_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantsPage extends StatefulWidget {
  String category_name;

  List<Restaurant> restaurant_list;
  RestaurantsPage(
      {Key? key, required this.restaurant_list, required this.category_name})
      : super(key: key);

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  //         UserData!.setDouble('locationLat', position.latitude);
  //         UserData!.setDouble('locationLon', position.longitude);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parseJson();
  }

  @override
  Widget build(BuildContext context) {
    final Color txt_color = Color(0xFF5a3769);
    final Color button_color = Color.fromARGB(255, 216, 107, 147);
    final double heightM = MediaQuery.of(context).size.height / 30;
    // double heightM = MediaQuery.of(context).size.height / 30;
    // Color txt_color = Colors.black;
    double rating;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: const Color(0xFF5a3769),
          ),
          backgroundColor: Colors.white,
          title: Text(widget.category_name),
          titleTextStyle: TextStyle(
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        body: Scrollbar(
          thickness: 10.0,
          radius: const Radius.circular(20),
          // width: 20,
          // color: Colors.black,
          child: ListView.builder(
            itemCount: widget.restaurant_list.length,
            itemBuilder: (BuildContext context, int index) {
              Restaurant item = widget.restaurant_list[index];
              print(item.location);
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
                child: InkWell(
                  onTap: () {
                    /// RestaurantDetails
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => RestaurantDetails(
                                category_name: widget.category_name,
                                restaurant: item,
                              )),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child:
                                // CarouselSlider(
                                //   options: CarouselOptions(height: heightM * 5.0),
                                //   items: item.photos?.map((i) {
                                //     return Builder(
                                //       builder: (BuildContext context) {
                                //         return Container(
                                //             width: MediaQuery.of(context).size.width,
                                //             margin:
                                //                 EdgeInsets.symmetric(horizontal: 5.0),
                                //             decoration: BoxDecoration(
                                //                 color: txt_color.withOpacity(0.5)),
                                //             child: CachedNetworkImage(
                                //                 imageUrl: "${i}",
                                //                 // child: Image.network("${i}",
                                //                 height: heightM * 5,
                                //                 width: heightM * 15,
                                //                 fit: BoxFit.fill));
                                //       },
                                //     );
                                //   }).toList(),
                                // )
                                Image.network("${item.photos?.first}",
                                    height: heightM * 7,
                                    width: heightM * 15,
                                    fit: BoxFit.fill)),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${item.name}",
                                  style: ourTextStyle(
                                      txt_color: Color(0xFF5a3769),
                                      txt_size: heightM * 0.7)),
                              Text("${getBuildPriceAvg(item)}",
                                  style: ourTextStyle(
                                      txt_color: Colors.black,
                                      txt_size: heightM * 0.5)),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                        //   child: Text("${item.description}",
                        //       style: ourTextStyle(
                        //           txt_color: Colors.grey, txt_size: heightM * 0.5)),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, bottom: 8.0, top: 3.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        // item.phoneNumber == "No phone number"
                                        //     ? print("no phone")
                                        //     : launchPhoneDialer(item.phoneNumber!);
                                      },
                                      child: Icon(
                                        Icons.star,
                                        color: Color(0xFF5a3769),
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      item.rateAVGNum != "0"
                                          ? item.rateAVG != null && item.rateAVGNum != null ?  "${item.rateAVG ?? " - "} / 5. rated by: ${item.rateAVGNum?? " - "} users" : " "
                                          : "No Rating Yet",
                                      style: ourTextStyle(
                                          txt_color: Colors.grey,
                                          txt_size: heightM * 0.5)),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        // MapsLauncher.launchCoordinates(
                                        //     double.parse(item.lat!),
                                        //     double.parse(item.long!));
                                      },
                                      child: const Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFF5a3769),
                                        size: 30,
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(item.far != null ? "${item.far ?? ""} KM" : "",
                                      style: ourTextStyle(
                                          txt_color: Colors.grey,
                                          txt_size: heightM * 0.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 10.0, bottom: 6.0, top: 1.0, right: 10.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           TextButton(
                        //             style: TextButton.styleFrom(
                        //               textStyle: const TextStyle(fontSize: 15),
                        //             ),
                        //             onPressed: () {
                        //               showModalBottomSheet<dynamic>(
                        //                 context: context,
                        //                 isScrollControlled: true,
                        //                 backgroundColor: Colors.transparent,
                        //                 builder: (context) => Container(
                        //                   //change the height of the bottom sheet
                        //                   height:
                        //                       MediaQuery.of(context).size.height *
                        //                           0.22,
                        //                   decoration: new BoxDecoration(
                        //                     color: Colors.white,
                        //                     borderRadius: new BorderRadius.only(
                        //                       topLeft: const Radius.circular(25.0),
                        //                       topRight: const Radius.circular(25.0),
                        //                     ),
                        //                   ),
                        //                   //content of the bottom sheet
                        //                   child: Column(
                        //                     // mainAxisAlignment:
                        //                     //     MainAxisAlignment.spaceEvenly,
                        //                     children: [
                        //                       SizedBox(
                        //                         height: 15,
                        //                       ),
                        //                       Container(
                        //                         height: 50,
                        //                         child: Text(
                        //                           "Rate & Review",
                        //                           style: TextStyle(
                        //                               fontSize: 25,
                        //                               fontWeight: FontWeight.bold,
                        //                               color: Color(0xFF5a3769)),
                        //                         ),
                        //                       ),
                        //                       Container(
                        //                         child: RatingBar.builder(
                        //                           minRating: 1,
                        //                           direction: Axis.horizontal,
                        //                           allowHalfRating: true,
                        //                           itemCount: 5,
                        //                           itemPadding: EdgeInsets.symmetric(
                        //                               horizontal: 4.0),
                        //                           itemBuilder: (context, _) => Icon(
                        //                             Icons.star,
                        //                             color: Colors.amber,
                        //                           ),
                        //                           onRatingUpdate: (double value) {
                        //                             rating = value;
                        //                             print(rating);
                        //                           },
                        //                         ),
                        //                       ),
                        //                       SizedBox(
                        //                         height: 15,
                        //                       ),
                        //                       Material(
                        //                           elevation: 10.0,
                        //                           borderRadius:
                        //                               BorderRadius.circular(
                        //                                   5.0), //12
                        //                           color: Colors
                        //                               .transparent, //Colors.cyan.withOpacity(0.5),
                        //                           child: MaterialButton(
                        //                             minWidth: 15,
                        //                             color: button_color,
                        //                             shape: RoundedRectangleBorder(
                        //                                 borderRadius:
                        //                                     BorderRadius.circular(
                        //                                         5.0)),
                        //                             splashColor: button_color,
                        //                             onPressed: () async {
                        //                               // Navigator.pop(context);
                        //                               // CoolAlert.show(
                        //                               //   context: context,
                        //                               //   type: CoolAlertType.confirm,
                        //                               //   text:
                        //                               //       'Do you want to submit this rate',
                        //                               //   confirmBtnText: 'Yes',
                        //                               //   cancelBtnText: 'No',
                        //                               //   confirmBtnColor:
                        //                               //       Color(0xFF5a3769),
                        //                               //   onConfirmBtnTap: () {
                        //                               //     Navigator.pop(context);
                        //                               //     Navigator.pop(context);
                        //                               //     Navigator.pop(context);
                        //
                        //                               //     //save the rate (backend)
                        //                               //   },
                        //                               // );
                        //                             },
                        //                             child: Text('Submit',
                        //                                 textAlign: TextAlign.center,
                        //                                 style: getMyTextStyle(
                        //                                     txt_color: Colors.white,
                        //                                     fontSize:
                        //                                         heightM * 0.6)),
                        //                           )
                        //                           // Container(
                        //                           //   child: TextButton(
                        //                           //       child: Text("Submit",
                        //                           //           style: TextStyle(
                        //                           //               color:
                        //                           //                   Color(0xFF5a3769),
                        //                           //               fontSize: 15,
                        //                           //               fontWeight:
                        //                           //                   FontWeight.bold)),
                        //                           //       onPressed: () {
                        //                           //         Navigator.pop(context);
                        //                           //         CoolAlert.show(
                        //                           //           context: context,
                        //                           //           type: CoolAlertType.confirm,
                        //                           //           text:
                        //                           //               'Do you want to submit this rate',
                        //                           //           confirmBtnText: 'Yes',
                        //                           //           cancelBtnText: 'No',
                        //                           //           confirmBtnColor:
                        //                           //               Color(0xFF5a3769),
                        //                           //           onConfirmBtnTap: () => {
                        //                           //             //save the rate (backend)
                        //                           //           },
                        //                           //         );
                        //                           //       },
                        //                           //       style: TextButton.styleFrom(
                        //                           //         textStyle: const TextStyle(
                        //                           //           fontSize: 15,
                        //                           //         ),
                        //                           //       )),
                        //                           ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //             child: Icon(
                        //               Icons.rate_review_outlined,
                        //               color: Color(0xFF5a3769),
                        //               size: 25,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
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

  Future parseJson() async {
    List<Rate> rateValues = [];
    final res = await FirebaseFirestore.instance
        .collection('rating')
        // .where("restID", isEqualTo: restaurant.id)
        // .orderBy('rate', descending: true)
        .get();

    for (var resRate in res.docs) {
      final rate = Rate.fromJson(resRate.data()) as Rate;
      rateValues.add(rate);
      // values.add(double.parse(rate.rate!));
    }
    print("values ${rateValues.length}");

    // List<Restaurant> restaurant_list_temp = [] ;
    for (int i = 0; i < widget.restaurant_list.length; i++) {
      var ffff = Geolocator.distanceBetween(
          (UserData?.getDouble('locationLat'))!,
          (UserData?.getDouble('locationLon'))!,
          double.parse("${widget.restaurant_list[i].lat}"),
          double.parse("${widget.restaurant_list[i].long}"));
      // print("distance: ${(ffff / 1000).toStringAsFixed(2)} KM");
      // print("ffff ${ffff}");
      widget.restaurant_list[i].far =
          double.parse((ffff / 1000).toStringAsFixed(2));
      print("far : ${widget.restaurant_list[i].far}");
      // restaurant_list_temp.add(widget.restaurant_list[i]);

      List<double> values = [];
      rateValues.forEach((element) {
        if (element.restId.toString() ==
            widget.restaurant_list[i].id.toString()) {
          values.add(double.tryParse(element.rate!)?? 0.0);
        }
      });
      // double average = values.sum() / values.length;
      double sum = values.fold(0, (prev, element) => prev + element);
      double average = sum / values.length;
      print("Average : ${average}");
      widget.restaurant_list[i].rateAVGNum = values.length.toString();
      double value = double.nan;

      if (average.compareTo(value) == 0) {
        widget.restaurant_list[i].rateAVG = "0";
      } else {
        widget.restaurant_list[i].rateAVG = average.toString();
      }

      // double average = mean(values);

    }

    widget.restaurant_list.sort((a, b) => a.far!.compareTo(b.far!));
    widget.restaurant_list.forEach((item) => print(item.name));
    setState(() {});
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
      color: txt_color,
      fontWeight: FontWeight.bold,
      fontSize: txt_size,
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<String> getUrlLocation(String url) async {
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    print(response.headers);
    return response.headers.value(HttpHeaders.locationHeader)!;
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    print(contactNumber);
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(_phoneUri)) await launchUrl(_phoneUri);
    } catch (error) {
      throw ("Cannot dial");
    }
  }
}

TextStyle getMyTextStyle({required Color txt_color, double fontSize = 22}) {
  return GoogleFonts.cairo(
      color: txt_color, fontSize: fontSize, fontWeight: FontWeight.bold);
}