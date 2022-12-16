import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'restaurant_model.dart';

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
  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color txt_color = Colors.black;
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
        body: ListView.builder(
          itemCount: widget.restaurant_list.length,
          itemBuilder: (BuildContext context, int index) {
            Restaurant item = widget.restaurant_list[index];
            print(item.location);
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
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
                        child: CarouselSlider(
                          options: CarouselOptions(height: heightM * 5.0),
                          items: item.photos?.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        color: txt_color.withOpacity(0.5)),
                                    child: Image.network("${i}",
                                        height: heightM * 5,
                                        width: heightM * 15,
                                        fit: BoxFit.fill));
                              },
                            );
                          }).toList(),
                        )
                        // Image.network("${item.photos?.first}",
                        //     height: heightM * 5,
                        //     width: heightM * 15,
                        //     fit: BoxFit.fill)
                        ),
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
                          Text("Price Average: ${item.priceAvg}",
                              style: ourTextStyle(
                                  txt_color: Colors.black,
                                  txt_size: heightM * 0.5)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                      child: Text("${item.description}",
                          style: ourTextStyle(
                              txt_color: Colors.grey, txt_size: heightM * 0.5)),
                    ),
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
                                    launchPhoneDialer(item.phoneNumber!);
                                  },
                                  child: Icon(
                                    Icons.call,
                                    color: Color(0xFF5a3769),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text("${item.phoneNumber}",
                                  style: ourTextStyle(
                                      txt_color: Colors.grey,
                                      txt_size: heightM * 0.5)),
                            ],
                          ),
                          InkWell(
                              onTap: () async {
                                _launchUrl(item.location!);
                              },
                              child: Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF5a3769),
                                size: 30,
                              )),
                          // InkWell(
                          //     onTap: () async {},
                          //     child: Icon(
                          //       Icons.favorite_border_rounded,
                          //       color: Color(0xFF5a3769),
                          //       size: 30,
                          //     )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
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
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(_phoneUri)) await launchUrl(_phoneUri);
    } catch (error) {
      throw ("Cannot dial");
    }
  }
}
