import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:belly_rate/category_parts/restaurant_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:loading_btn/loading_btn.dart';
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
  double? ratee = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      getRate();
    });

    print("rattte");
    // print(widget.restaurant.rate!.rate);
    if (widget.restaurant.rate?.rate != null) {
      print("rattte");
      print(widget.restaurant.rate!.rate);
      var rateD = double.tryParse(widget.restaurant.rate!.rate.toString());
      print(rateD);
    }

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
        actions: [
          IconButton(
            padding: EdgeInsets.only(
              right: 15,
            ),
            onPressed: () async {
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.info,
                  text: '\$: Low \n \$\$: Average \n \$\$\$: High',
                  confirmBtnText: 'Ok',
                  confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                  title: "Price Description",
                  onConfirmBtnTap: () async {
                    Navigator.of(context).pop(true);
                  });
            },
            icon: Icon(
              Icons.info_outline_rounded,
              color: const Color(0xFF5a3769),
              size: 28,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: heightM * 10.0,
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
                              ? button_color
                              : Color.fromARGB(255, 105, 105, 105)),
                    );
                  },
                ).toList(), // this was the part the I had to add
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 0.0, top: 3.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.restaurant.name}",
                    style: ourTextStyle(
                        txt_color: Color(0xFF5a3769), txt_size: heightM * 0.8)),
                if (widget.restaurant.rate != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0.0),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 0.0, top: 3.0, right: 16.0),
                        child: ratee == 0.5
                            ? StarWidget5()
                            : ratee == 1.5
                                ? StarWidget15()
                                : ratee == 2.5
                                    ? StarWidget25()
                                    : ratee == 3.5
                                        ? StarWidget35()
                                        : ratee == 4.5
                                            ? StarWidget45()
                                            : StarWidget(
                                                activated: ratee!,
                                              )),
                  ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, bottom: 0.0, top: 0.0, right: 16.0),
              child: Text(
                  "${getBuildPriceAvg(widget.restaurant)}"
                  // == '\$\$'
                  //     ? " \$\$\$-\$\$"
                  //     : "b"
                  ,
                  style: ourTextStyle(
                      txt_color: Color.fromARGB(255, 216, 107, 147),
                      txt_size: heightM * 0.6))),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 3.0, top: 0.0, right: 16.0),
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
                          // print("no phone ${widget.restaurant.phoneNumber!.trim().toString().toLowerCase() == "No phone number"!.trim().toString().toLowerCase()}") ;
                          // print("no phone ${widget.restaurant.phoneNumber}") ;
                          widget.restaurant.phoneNumber!
                                      .trim()
                                      .toString()
                                      .toLowerCase() ==
                                  "No phone number".toString().toLowerCase()
                              ? print("no phone")
                              : launchPhoneDialer(
                                  widget.restaurant.phoneNumber!);
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
                            txt_color: Colors.grey, txt_size: heightM * 0.55)),
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
                              MapsLauncher.launchCoordinates(
                                  double.parse(widget.restaurant.lat!),
                                  double.parse(widget.restaurant.long!));
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
                                  txt_color: Colors.grey,
                                  txt_size: heightM * 0.55)),
                        ),
                      ],
                    ),
                  ),
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
                            String rating = "0";

                            showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                //change the height of the bottom sheet
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                ),
                                //content of the bottom sheet
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                      child: Text(
                                        "Give a Rate",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5a3769)),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 60,
                                        child: Center(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    3, 0, 15, 0),
                                                child: Align(
                                                  child: Text(
                                                    "How much do you rate ${widget.restaurant.name} restaurant?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 20,

                                                        // fontWeight: FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255,
                                                            110,
                                                            110,
                                                            110)),
                                                  ),
                                                  alignment: Alignment.center,
                                                )))),
                                    RatingBar.builder(
                                      minRating: 0.5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      glowColor: Color(0xFF5a3769),
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star_rate_rounded,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (double value) {
                                        setState(() {
                                          ratee = value;
                                          rating = value.toString();
                                        });

                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    LoadingBtn(
                                      height: 45,
                                      borderRadius: 8,
                                      animate: true,
                                      color: Color.fromARGB(255, 216, 107, 147),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      loader: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 40,
                                        height: 40,
                                        child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      child: const Text(
                                        "Rate",
                                        style: TextStyle(
                                          // color: Color(0xFF5a3769),
                                          fontSize: 20,
                                        ),
                                      ),
                                      onTap: (startLoading, stopLoading,
                                          btnState) async {
                                        if (btnState == ButtonState.idle) {
                                          startLoading();

                                          bool isRate = await addRate(
                                                  rate: rating.toString(),
                                                  restID: widget.restaurant.id!)
                                              .then((value) {
                                            isDone = false;
                                            setState(() {
                                              // historyList.clear();
                                            });
                                            getRate();
                                            return true;
                                          });

                                          if (isRate) {
                                            stopLoading();
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
                                                              0.27,
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
                                                            height: 28,
                                                          ),
                                                          const SizedBox(
                                                            height: 50,
                                                            child: Icon(
                                                              Icons
                                                                  .favorite_border_outlined,
                                                              color: Color(
                                                                  0xFF5a3769),
                                                              size: 45,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 40,
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
                                                            height: 22,
                                                            child: Text(
                                                              "Your opinion matters to us",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
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
                                            print("isRate");
                                          } else {
                                            stopLoading();

                                            print("No isRate");
                                          }
                                          // stopLoading();

                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text('Rate ${widget.restaurant.name}',
                              textAlign: TextAlign.center,
                              style: ourTextStyle(
                                  txt_color: Colors.white,
                                  txt_size: heightM * 0.6)),
                        ),
                      ),
                    ),
                  ),
                ),
              // if (widget.restaurant.rate != null)
              //   Padding(
              //     padding: const EdgeInsets.only(
              //         left: 16.0, bottom: 3.0, top: 20.0, right: 16.0),
              //     child: Text("Your Rate: ${widget.restaurant.rate?.rate}",
              //         style: ourTextStyle(
              //             txt_color: Color.fromARGB(255, 216, 107, 147),
              //             txt_size: heightM * 0.55)),
              //   ),
            ],
          )
        ],
      ),
    );
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
      ratee = double.tryParse(widget.restaurant.rate!.rate.toString());
      setState(() {
        ratee = double.tryParse(widget.restaurant.rate!.rate.toString());
      });
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

      final uri =
          Uri.parse('https://bellyrate-urhmg.ondigitalocean.app/ratings');
      final response = await post(uri,
          body: json.encode({
            'rating': [user?.uid, restID, rate, rate, rate]
          }));
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

class StarWidget extends StatelessWidget {
  final int total;
  final double activated;

  const StarWidget({Key? key, this.total = 5, required this.activated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        var filled = index < activated;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: Color.fromARGB(255, 216, 107, 147),
        );
      }).toList(),
    );
  }
}

class StarWidget5 extends StatelessWidget {
  const StarWidget5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.star_half_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
    ]);
  }
}

class StarWidget15 extends StatelessWidget {
  const StarWidget15({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_half_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
    ]);
  }
}

class StarWidget25 extends StatelessWidget {
  const StarWidget25({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_half_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
    ]);
  }
}

class StarWidget35 extends StatelessWidget {
  const StarWidget35({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_half_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_outline_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
    ]);
  }
}

class StarWidget45 extends StatelessWidget {
  const StarWidget45({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
      Icon(
        Icons.star_half_rounded,
        color: Color.fromARGB(255, 216, 107, 147),
      ),
    ]);
  }
}
