import 'package:belly_rate/category_parts/restaurant_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/rateModel.dart';

class RestaurantDetails extends StatefulWidget {
  String category_name;
  Restaurant restaurant;

  RestaurantDetails(
      {Key? key, required this.restaurant, required this.category_name})
      : super(key: key);
  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  User? user;
  int _current = 0;
  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      getRate();
    });

    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    final Color txt_color = const Color(0xFF5a3769);
    final Color button_color = const Color.fromARGB(255, 216, 107, 147);
    final double heightM = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: const Color(0xFF5a3769),
        ),
        backgroundColor: Colors.white,
        title: Text(widget.category_name),
        titleTextStyle: const TextStyle(
          color: Color(0xFF5a3769),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: heightM * 8.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: widget.restaurant.photos?.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration:
                              BoxDecoration(color: txt_color.withOpacity(0.5)),
                          child: CachedNetworkImage(
                              imageUrl: "${i}",
                              // child: Image.network("${i}",
                              height: heightM * 8,
                              width: heightM * 50,
                              fit: BoxFit.fill));
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.restaurant.photos!.map(
                  (image) {
                    int index = widget.restaurant.photos!.indexOf(image);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? txt_color
                              // ? const Color.fromRGBO(255,255, 255, 0.9)
                              : button_color
                          // : const Color.fromRGBO(255,255, 255, 0.4)
                          ),
                    );
                  },
                ).toList(), // this was the part the I had to add
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.restaurant.name}",
                    style: ourTextStyle(
                        txt_color: Color(0xFF5a3769), txt_size: heightM * 0.8)),
                Text("${getBuildPriceAvg(widget.restaurant)}",
                    style: ourTextStyle(
                        txt_color: Colors.black, txt_size: heightM * 0.6)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
            child: Text("${widget.restaurant.description}",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: ourTextStyle(
                    txt_color: Colors.grey, txt_size: heightM * 0.5)),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 3.0, top: 10.0, right: 16.0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          // item.phoneNumber == "No phone number"
                          //     ? print("no phone")
                          //     : launchPhoneDialer(item.phoneNumber!);
                        },
                        child: Icon(
                          Icons.call,
                          color: Color(0xFF5a3769),
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text("${widget.restaurant.phoneNumber}",
                        style: ourTextStyle(
                            txt_color: Colors.grey, txt_size: heightM * 0.5)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, bottom: 3.0, top: 10.0, right: 5.0),
                    child: Row(
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
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            MapsLauncher.launchCoordinates(
                                double.parse(widget.restaurant.lat!),
                                double.parse(widget.restaurant.long!));
                          },
                          child: Text("Open with Google Maps",
                              style: ourTextStyle(
                                  txt_color: Color(0xFF5a3769),
                                  txt_size: heightM * 0.5)),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 0.0, bottom: 3.0, top: 10.0, right: 0.0),
                  //   child: Center(
                  //     child: InkWell(
                  //       onTap: () async {
                  //         MapsLauncher.launchCoordinates(
                  //             double.parse(widget.restaurant.lat!),
                  //             double.parse(widget.restaurant.long!));
                  //
                  //       },
                  //       child: Text('Open with Google Maps',
                  //           textAlign: TextAlign.center,
                  //           style: ourTextStyle(
                  //               txt_color: Colors.black, txt_size: heightM * 0.5)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              if (widget.restaurant.rate == null && isDone)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 3.0, top: 20.0, right: 16.0),
                  child: Center(
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.9,
                      height: heightM * 1.5,
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(10.0), //12
                        color:
                            Colors.transparent, //Colors.cyan.withOpacity(0.5),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width * 0.1,
                          color: button_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          splashColor: button_color,
                          onPressed: () async {
                            print("qqq");
                            String rating = "";

                            showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                //change the height of the bottom sheet
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                ),
                                //content of the bottom sheet
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      height: 50,
                                      child: Text(
                                        "Rate & Review",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5a3769)),
                                      ),
                                    ),
                                    RatingBar.builder(
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      glowColor: Color(0xFF5a3769),
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (double value) {
                                        rating = value.toString();
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Material(
                                        elevation: 10.0,
                                        borderRadius:
                                            BorderRadius.circular(5.0), //12
                                        color: Colors
                                            .transparent, //Colors.cyan.withOpacity(0.5),
                                        child: MaterialButton(
                                          minWidth: 15,
                                          color: button_color,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          splashColor: button_color,
                                          onPressed: () async {
                                            bool isRate = await addRate(
                                                    rate: rating.toString(),
                                                    restID:
                                                        widget.restaurant.id!)
                                                .then((value) {
                                              isDone = false;
                                              setState(() {
                                                // historyList.clear();
                                              });
                                              getRate();
                                              return true;
                                            });

                                            if (isRate) {
                                              print("isRate");
                                            } else {
                                              print("No isRate");
                                            }
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) => Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.22,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  25.0),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          const SizedBox(
                                                            height: 50,
                                                            child: Icon(
                                                              Icons
                                                                  .favorite_border_outlined,
                                                              color: Color(
                                                                  0xFF5a3769),
                                                              size: 30,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 50,
                                                            child: Text(
                                                              "Thanks for your rating!",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF5a3769),
                                                                fontSize: 25,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            child: Text(
                                                              "Your opinion matters to us",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          Material(
                                                              elevation: 10.0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0), //12
                                                              color: Colors
                                                                  .transparent,
                                                              child:
                                                                  MaterialButton(
                                                                      minWidth:
                                                                          15,
                                                                      color:
                                                                          button_color,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5.0)),
                                                                      splashColor:
                                                                          button_color,
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Sure!',
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: ourTextStyle(
                                                                              txt_color: Colors.white,
                                                                              txt_size: heightM * 0.6)))),
                                                        ],
                                                      ),
                                                    ));
                                          },
                                          child: Text('Submit',
                                              textAlign: TextAlign.center,
                                              style: ourTextStyle(
                                                  txt_color: Colors.white,
                                                  txt_size: heightM * 0.6)),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text('Rate & Review',
                              textAlign: TextAlign.center,
                              style: ourTextStyle(
                                  txt_color: Colors.white,
                                  txt_size: heightM * 0.6)),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.restaurant.rate != null)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 3.0, top: 20.0, right: 16.0),
                  child: Text("Your Rate: ${widget.restaurant.rate?.rate}",
                      style: ourTextStyle(
                          txt_color: Color.fromARGB(255, 216, 107, 147),
                          txt_size: heightM * 0.55)),
                ),
            ],
          )
        ],
      ),
    );
  }

  getRate() async {
    final UID = FirebaseAuth.instance.currentUser!.uid;
    final rateRes = await FirebaseFirestore.instance
        .collection('rating')
        .where("UID", isEqualTo: UID)
        .where("restID", isEqualTo: widget.restaurant.id)
        .get();
    for (var Category in rateRes.docs) {
      final rate = Rate.fromJson(Category.data()) as Rate;
      widget.restaurant.rate = rate;
    }
    isDone = true;
    setState(() {});
  }

  Future<bool> addRate({required String rate, required String restID}) async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore.collection("rating").add({
      'rateID': '',
      'UID': '${user?.uid}',
      'rate': rate,
      'restID': restID,
      // Add more fields as needed
    }).then((value) async {
      await _firestore
          .collection("rating")
          .doc(value.id)
          .update({"rateID": value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
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

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
      color: txt_color,
      fontWeight: FontWeight.bold,
      fontSize: txt_size,
    );
  }
}
