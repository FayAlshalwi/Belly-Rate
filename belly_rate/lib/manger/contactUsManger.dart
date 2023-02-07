import 'package:belly_rate/manger/requestDetails.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/ticketSupport.dart';

class ContactUsManger extends StatefulWidget {
  const ContactUsManger({Key? key}) : super(key: key);

  @override
  State<ContactUsManger> createState() => _contactUsMangerState();
}

class _contactUsMangerState extends State<ContactUsManger> {
  User? user;
  int requestsIndex = 0;
  TextEditingController text = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "User Request",
          style: TextStyle(
            fontSize: 22,
            color: mainColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<TicketSupport>>(
            stream: getRequest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _list = snapshot.data!;
                List<TicketSupport?> _listCompleted = [];
                List<TicketSupport?> _listInProgress = [];
                _list.forEach((element) {
                  print("0000 ${element.status}");
                  if (element.status.toString().toString().toLowerCase() ==
                      "Completed".toLowerCase()) {
                    _listCompleted.add(element);
                  } else if (element.status.toString().toLowerCase() ==
                      "In Progress".toLowerCase()) {
                    _listInProgress.add(element);
                  }
                });
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: requestsIndex == 0
                                ? button_color
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                requestsIndex = 0;
                              });
                            },
                            child: Text(
                              "In Progress",
                              style: ourTextStyle(
                                color: requestsIndex != 0
                                    ? Colors.black
                                    : Colors.white,
                                //Colors.orange,
                                // fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: requestsIndex == 1
                                ? button_color
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                requestsIndex = 1;
                              });
                            },
                            child: Text(
                              "Completed",
                              style: ourTextStyle(
                                color: requestsIndex != 1
                                    ? Colors.black
                                    : Colors.white,
                                //Colors.orange,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (requestsIndex == 1)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _listCompleted.length,
                          itemBuilder: (BuildContext context, int index) {
                            TicketSupport ticket = _listCompleted[index]!;
                            return buildContainerCardViewCompleted(ticket);
                          }),
                    if (requestsIndex == 0)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _listInProgress.length,
                          itemBuilder: (BuildContext context, int index) {
                            TicketSupport ticket = _listInProgress[index]!;
                            print("wwww ${ticket.status}");
                            return buildContainerCardView(ticket);
                          }),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Some thing went wrong! ${snapshot.error}");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Container buildContainerCard(TicketSupport ticket) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: mainColor(),
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8.0 , right: 8.0),
                  //   child: Text(
                  //     "Title:",
                  //     style: ourTextStyle(
                  //         color: const Color.fromARGB(255, 216, 107, 147), fontSize: 17),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8.0 , right: 8.0),
                  //   child: Text(
                  //     "${ticket.requestTitle}",
                  //     style: ourTextStyle(
                  //         color: mainColor(), fontSize: 15),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "Subject:",
                      style: ourTextStyle(
                          color: const Color.fromARGB(255, 216, 107, 147),
                          fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${ticket.requestText}",
                      style: ourTextStyle(color: mainColor(), fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "User:",
                      style: ourTextStyle(
                          color: const Color.fromARGB(255, 216, 107, 147),
                          fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${ticket.username}",
                      style: ourTextStyle(color: mainColor(), fontSize: 15),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "Request Date:",
                      style: ourTextStyle(
                          color: const Color.fromARGB(255, 216, 107, 147),
                          fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))}",
                      style: ourTextStyle(color: mainColor(), fontSize: 15),
                    ),
                  ),

                  if (ticket.status != "In Progress")
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: ticket.status != "In Progress"
                            ? Radius.circular(15.0)
                            : Radius.circular(0.0),
                        bottomRight: ticket.status != "In Progress"
                            ? Radius.circular(15.0)
                            : Radius.circular(0.0),
                      ),
                      child: Container(
                        color: Colors.cyan.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Answer Date:",
                                    style: ourTextStyle(
                                        color: const Color.fromARGB(
                                            255, 216, 107, 147),
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.answerDateTime!.millisecondsSinceEpoch))}",
                                    style: ourTextStyle(
                                        color: mainColor(), fontSize: 15),
                                  ),
                                  Text(
                                    "Manger Answer:",
                                    style: ourTextStyle(
                                        color: const Color.fromARGB(
                                            255, 216, 107, 147),
                                        fontSize: 17),
                                  ),
                                  Text(
                                    ticket.requestAnswer!,
                                    style: ourTextStyle(
                                        color: mainColor(), fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (ticket.status == "In Progress")
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                child: InkWell(
                  onTap: () {
                    ///
                    _showBottomSheet(context, ticket.requestId!);
                  },
                  child: Container(
                    color: mainColor(),
                    width: 500,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "write Your Reply here",
                        style: ourTextStyle(color: Colors.white, fontSize: 13),
                      ),
                    )),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildContainerCardViewCompleted(TicketSupport ticket) {
    final double heightM = MediaQuery.of(context).size.height / 30;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///
            Expanded(
              child: InkWell(
                onTap: () {
                  /// RequestDetails
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => RequestDetails(
                              ticket: ticket,
                            )),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2)),
                        child: Center(
                          child: Text(
                            "${ticket.username!.substring(0, 1).toUpperCase()}",
                            style:
                                ourTextStyle(fontSize: 20, color: Colors.black
                                    // fontWeight: FontWeight.bold
                                    ),
                          ),
                        ),
                      ),
                    ),

                    ///
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                  "${ticket.requestTitle!.isNotEmpty ? ticket.requestTitle! : "No title"}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: Color(0xFF5a3769), fontSize: 16)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text("Request User : ${ticket.username}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: button_color,
                                      fontSize: heightM * 0.4)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                  "Request Date : ${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: button_color,
                                      fontSize: heightM * 0.4)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                  "Answer Date : ${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.answerDateTime!.millisecondsSinceEpoch))}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: mainColor(),
                                      fontSize: heightM * 0.4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ///
            // if (item.rate == null)
            //   InkWell(
            //     onTap: () {
            //       print("qqq");
            //       String rating = "";
            //
            //       showModalBottomSheet<dynamic>(
            //         context: context,
            //         isScrollControlled: true,
            //         backgroundColor: Colors.transparent,
            //         builder: (context) => Container(
            //           //change the height of the bottom sheet
            //           height: MediaQuery.of(context).size.height * 0.22,
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(25.0),
            //               topRight: Radius.circular(25.0),
            //             ),
            //           ),
            //           //content of the bottom sheet
            //           child: Column(
            //             // mainAxisAlignment:
            //             //     MainAxisAlignment.spaceEvenly,
            //             children: [
            //               const SizedBox(
            //                 height: 15,
            //               ),
            //               const SizedBox(
            //                 height: 50,
            //                 child: Text(
            //                   "Rate & Review",
            //                   style: TextStyle(
            //                       fontSize: 25,
            //                       fontWeight: FontWeight.bold,
            //                       color: Color(0xFF5a3769)),
            //                 ),
            //               ),
            //               RatingBar.builder(
            //                 minRating: 1,
            //                 direction: Axis.horizontal,
            //                 allowHalfRating: true,
            //                 glowColor: Color(0xFF5a3769),
            //                 itemCount: 5,
            //                 itemPadding:
            //                 EdgeInsets.symmetric(horizontal: 4.0),
            //                 itemBuilder: (context, _) => Icon(
            //                   Icons.star,
            //                   color: Colors.amber,
            //                 ),
            //                 onRatingUpdate: (double value) {
            //                   rating = value.toString();
            //                   print(rating);
            //                 },
            //               ),
            //               SizedBox(
            //                 height: 15,
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.only(
            //           left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
            //       child:
            //       Icon(Icons.star_border, color: Colors.pinkAccent),
            //     ),
            //   ),
            //
            // if (item.rate != null)
            //   const Padding(
            //     padding: EdgeInsets.only(
            //         left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
            //     child: Icon(Icons.star, color: Colors.pinkAccent),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget buildContainerCardView(TicketSupport ticket) {
    final double heightM = MediaQuery.of(context).size.height / 30;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///
            Expanded(
              child: InkWell(
                onTap: () {
                  /// RequestDetails
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => RequestDetails(
                              ticket: ticket,
                            )),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2)),
                        child: Center(
                          child: Text(
                            "${ticket.username!.substring(0, 1).toUpperCase()}",
                            style:
                                ourTextStyle(fontSize: 20, color: Colors.black
                                    // fontWeight: FontWeight.bold
                                    ),
                          ),
                        ),
                      ),
                    ),

                    ///
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                  "${ticket.requestTitle!.isNotEmpty ? ticket.requestTitle! : "No title"}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: Color(0xFF5a3769), fontSize: 16)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text("Request User : ${ticket.username}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: button_color,
                                      fontSize: heightM * 0.4)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                  "Request Date : ${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: ourTextStyle(
                                      color: button_color,
                                      fontSize: heightM * 0.4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ///
            // if (item.rate == null)
            //   InkWell(
            //     onTap: () {
            //       print("qqq");
            //       String rating = "";
            //
            //       showModalBottomSheet<dynamic>(
            //         context: context,
            //         isScrollControlled: true,
            //         backgroundColor: Colors.transparent,
            //         builder: (context) => Container(
            //           //change the height of the bottom sheet
            //           height: MediaQuery.of(context).size.height * 0.22,
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(25.0),
            //               topRight: Radius.circular(25.0),
            //             ),
            //           ),
            //           //content of the bottom sheet
            //           child: Column(
            //             // mainAxisAlignment:
            //             //     MainAxisAlignment.spaceEvenly,
            //             children: [
            //               const SizedBox(
            //                 height: 15,
            //               ),
            //               const SizedBox(
            //                 height: 50,
            //                 child: Text(
            //                   "Rate & Review",
            //                   style: TextStyle(
            //                       fontSize: 25,
            //                       fontWeight: FontWeight.bold,
            //                       color: Color(0xFF5a3769)),
            //                 ),
            //               ),
            //               RatingBar.builder(
            //                 minRating: 1,
            //                 direction: Axis.horizontal,
            //                 allowHalfRating: true,
            //                 glowColor: Color(0xFF5a3769),
            //                 itemCount: 5,
            //                 itemPadding:
            //                 EdgeInsets.symmetric(horizontal: 4.0),
            //                 itemBuilder: (context, _) => Icon(
            //                   Icons.star,
            //                   color: Colors.amber,
            //                 ),
            //                 onRatingUpdate: (double value) {
            //                   rating = value.toString();
            //                   print(rating);
            //                 },
            //               ),
            //               SizedBox(
            //                 height: 15,
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.only(
            //           left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
            //       child:
            //       Icon(Icons.star_border, color: Colors.pinkAccent),
            //     ),
            //   ),
            //
            // if (item.rate != null)
            //   const Padding(
            //     padding: EdgeInsets.only(
            //         left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
            //     child: Icon(Icons.star, color: Colors.pinkAccent),
            //   ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String ticketID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Write your Reply here',
                      labelStyle: ourTextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: button_color,
                      onPressed: () {
                        if (text.text.isNotEmpty) {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              text:
                                  'Are you sure you want to reply on this request?',
                              confirmBtnText: 'Yes',
                              cancelBtnText: 'Cancel',
                              confirmBtnColor:
                                  Color.fromARGB(255, 216, 107, 147),
                              title: "Submit Reply",
                              onCancelBtnTap: () {
                                Navigator.of(context).pop(true);
                              },
                              onConfirmBtnTap: () async {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.loading,
                                  text: "Loading",
                                );

                                await replyRequest(
                                    text_m: text.text, requestId: ticketID);

                                text.clear();

                                CoolAlert.show(
                                  title: "Success",
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Request Replied successfully!",
                                  confirmBtnColor:
                                      Color.fromARGB(255, 216, 107, 147),
                                  onConfirmBtnTap: () {
                                    Navigator.of(context).pop(true);
                                    Navigator.of(context).pop(true);
                                    Navigator.of(context).pop(true);
                                    Navigator.of(context).pop(true);
                                  },
                                );
                              });
                        } else {
                          CoolAlert.show(
                            context: context,
                            title: "Text Empty",
                            type: CoolAlertType.error,
                            text: "Please Fill Request Reply",
                            confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                          );
                        }
                      },
                      child: Text(
                        "Reply on Request",
                        style: ourTextStyle(
                          color: Colors.white, //Colors.orange,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> replyRequest(
      {required String text_m, required String requestId}) async {
    final _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection("users_requests").doc(requestId).update(
        {
          "status": "Completed",
          "request_answer": text_m,
          "answer_date_time": DateTime.now(),
        },
      );
      text.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<TicketSupport>> getRequest() {
    return FirebaseFirestore.instance
        .collection('users_requests')
        .snapshots()
        .map((event) {
      List<TicketSupport> reqList = [];
      for (var req in event.docs) {
        final rate = TicketSupport.fromJson(req.data()) as TicketSupport;
        reqList.add(rate);
      }

      return reqList;
    });
  }

  TextStyle ourTextStyle({required Color color, required double fontSize}) {
    return GoogleFonts.cairo(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
  }

  Color button_color = Color.fromARGB(255, 216, 107, 147);

  Color mainColor() => const Color(0xFF5a3769);
}
