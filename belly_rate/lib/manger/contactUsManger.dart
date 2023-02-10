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
          "User Requests",
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
                                    ? const Color(0xFF5a3769)
                                    : Colors.white,
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
                                    ? const Color(0xFF5a3769)
                                    //Colors.black
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

  Widget buildContainerCardViewCompleted(TicketSupport ticket) {
    final double heightM = MediaQuery.of(context).size.height / 30;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, bottom: 1.0, top: 3.0, right: 16.0),
      child: Container(
          height: 90,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          useRootNavigator: false,
                          isDismissible: true,
                          enableDrag: true,
                          context: context,
                          isScrollControlled: false,
                          builder: (context) {
                            return Container(
                                height: 430,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, bottom: 0.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        "${ticket.requestTitle!.isNotEmpty ? ticket.requestTitle : "No Subject"}",
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          color: mainColor(),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))} - ${ticket.status}",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: mainColor(),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        "From",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: mainColor(),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 4,
                                                              right: 8.0),
                                                      child: Text(
                                                        "${ticket.username}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        "Request description",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: mainColor(),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 4,
                                                              right: 8.0),
                                                      child: Text(
                                                        "${ticket.requestText!.isNotEmpty ? ticket.requestText : "No Subject"}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    if (ticket.status !=
                                                        "In Progress")
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft: ticket
                                                                      .status !=
                                                                  "In Progress"
                                                              ? Radius.circular(
                                                                  15.0)
                                                              : Radius.circular(
                                                                  0.0),
                                                          bottomRight: ticket
                                                                      .status !=
                                                                  "In Progress"
                                                              ? Radius.circular(
                                                                  15.0)
                                                              : Radius.circular(
                                                                  0.0),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 394,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              12,
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "Answer Date",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              mainColor(),
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8.0,
                                                                          top:
                                                                              4,
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.answerDateTime!.millisecondsSinceEpoch))}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              12,
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "Manger Answer",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              mainColor(),
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8.0,
                                                                          top:
                                                                              4,
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "${ticket.requestAnswer}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color(0xFF5a3769), width: 2)),
                            child: Center(
                              child: Text(
                                "${ticket.requestTitle!.substring(0, 1).toUpperCase()}",
                                style: ourTextStyle(
                                    fontSize: 25, color: Color(0xFF5a3769)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                bottom: 9.0,
                                top: 12.0,
                                right: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                      "${ticket.requestTitle!.isNotEmpty ? ticket.requestTitle! : "No title"}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF5a3769))),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 2.0,
                                      top: 3.0,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        "${ticket.username}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 216, 107, 147)),
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 3.0,
                                      top: 3.0,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                          "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: heightM * 0.4,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5a3769))),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildContainerCardView(TicketSupport ticket) {
    final double heightM = MediaQuery.of(context).size.height / 30;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, bottom: 1.0, top: 3.0, right: 16.0),
      child: Container(
          height: 90,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => RequestDetails(
                                  ticket: ticket,
                                )),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color(0xFF5a3769), width: 2)),
                            child: Center(
                              child: Text(
                                "${ticket.requestTitle!.substring(0, 1).toUpperCase()}",
                                style: ourTextStyle(
                                    fontSize: 25, color: Color(0xFF5a3769)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                bottom: 9.0,
                                top: 12.0,
                                right: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                      "${ticket.requestTitle!.isNotEmpty ? ticket.requestTitle! : "No title"}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF5a3769))),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 2.0,
                                      top: 3.0,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        "${ticket.username}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 216, 107, 147)),
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 3.0,
                                      top: 3.0,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                          "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: heightM * 0.4,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5a3769))),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
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
