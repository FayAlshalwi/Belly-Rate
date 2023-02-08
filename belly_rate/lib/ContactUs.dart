import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth/our_user_model.dart';
import 'manger/requestDetails.dart';
import 'models/ticketSupport.dart';
import 'package:intl/intl.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  int requestsIndex = 0;
  User? user;
  OurUser? ourUser;
  bool invalidD = false;
  bool invalidT = false;

  TextEditingController textTitle = TextEditingController();
  TextEditingController textDescription = TextEditingController();
  final _formtext = GlobalKey<FormState>();
  final _formdescription = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser!;

    Future.delayed(Duration.zero).then((value) async {
      var vari = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .get();
      // Map<String,dynamic> userData = vari as Map<String,dynamic>;
      print("currentUser: ${vari.data()}");

      ourUser = OurUser(
        name: vari.data()!['name'],
        // first_name: vari.data()!['firstName'],
        picture: vari.data()!['picture'],
        phone_number: vari.data()!['phoneNumber'],
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: BackButton(
          color: mainColor(),
        ),
        title: Text(
          "Contact Us",
          style: TextStyle(
            fontSize: 22,
            color: mainColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    color: requestsIndex == 0 ? button_color : Colors.white,
                    onPressed: () {
                      setState(() {
                        requestsIndex = 0;
                      });
                    },
                    child: Text(
                      "New Request",
                      style: ourTextStyle(
                        color: requestsIndex != 0 ? Colors.black : Colors.white,
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
                    color: requestsIndex == 1 ? button_color : Colors.white,
                    onPressed: () {
                      setState(() {
                        requestsIndex = 1;
                      });
                    },
                    child: Text(
                      "Previous Requests",
                      style: ourTextStyle(
                        color: requestsIndex != 1 ? Colors.black : Colors.white,
                        //Colors.orange,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (requestsIndex == 0) addNewRequest(context),
            if (requestsIndex == 1)
              StreamBuilder<List<TicketSupport>>(
                  stream: getRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final _list = snapshot.data!;

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            _list
                                .sort((a, b) => b.status!.compareTo(a.status!));
                            TicketSupport ticket = _list[index];
                            if (ticket.status == "In Progress") {
                              return buildContainerCardView(ticket);
                              // return buildInProgressCard(ticket);
                            } else {
                              return buildContainerCardViewCompletedNew(ticket);
                              // return buildCompleteCard(ticket);
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text("Some thing went wrong! ${snapshot.error}");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
          ],
        ),
      ),
    );
  }

  Card buildCompleteCard(TicketSupport ticket) {
    return Card(
      child: ClipRect(
        child: Banner(
          message: "${ticket.status}",
          location: BannerLocation.topEnd,
          color: const Color.fromARGB(255, 216, 107, 147),
          child: buildContainerCard(ticket),
        ),
      ),
    );
  }

  Card buildInProgressCard(TicketSupport ticket) {
    return Card(
      child: ClipRect(
        child: Banner(
          message: "${ticket.status}",
          location: BannerLocation.topEnd,
          color: mainColor(),
          child: buildContainerCard(ticket),
        ),
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
                  //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  //   child: Text(
                  //     "Title:",
                  //     style: ourTextStyle(
                  //         color: const Color.fromARGB(255, 216, 107, 147),
                  //         fontSize: 17),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  //   child: Text(
                  //     "${ticket.requestTitle}",
                  //     style: ourTextStyle(color: mainColor(), fontSize: 15),
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                        ),
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container addNewRequest(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      // width: 390,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text(
                "Add New Request",
                style: ourTextStyle(color: mainColor(), fontSize: 20),
              ),
              Center(
                child: Text(
                  "Please kindly provide a detailed description of your problem, and our team will get back to you in the shortest time possible."
                  " We are always here to help and eager to assist you with any concerns you may have. Rest assured that we will do our best to provide a prompt "
                  "and satisfactory solution to your issue.",
                  style: ourTextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formtext,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: textTitle,
                  onChanged: (_) {
                    _formtext.currentState!.validate();
                  },
                  validator: (value) {
                    final RegExp regex = RegExp(r"^[a-zA-Z0-9 \n.]+$");

                    // RegExp regExp = new RegExp(pattern);
                    if (value!.isEmpty) {
                      invalidT = true;
                      return "Title cant be empty";
                    }
                    if (!regex.hasMatch(value!)) {
                      invalidT = true;
                      return "Special characters are not allowed";
                    }
                    if (value!.length < 3) {
                      invalidT = true;
                      return "Min input length is 3 characters.";
                    }
                    if (value!.length > 25) {
                      invalidT = true;
                      return "Max input length is 25 characters.";
                    } else {
                      invalidT = false;
                      return null;
                    }
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    errorStyle: ourTextStyle(color: Colors.red, fontSize: 13),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor())),
                    labelText: 'choose a title for your problem',
                    labelStyle: ourTextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formdescription,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: textDescription,
                  onChanged: (_) {
                    _formdescription.currentState!.validate();
                  },
                  validator: (value) {
                    final RegExp regex = RegExp(r"^[a-zA-Z0-9 \n.]+$");

                    // RegExp regExp = new RegExp(pattern);
                    if (value!.isEmpty) {
                      invalidD = true;
                      return "Description cant be empty";
                    }
                    if (!regex.hasMatch(value!)) {
                      invalidD = true;
                      return "Only letters and numbers are allowed";
                    }
                    if (value!.length < 3) {
                      invalidD = true;
                      return "Min input length is 3 characters.";
                    }
                    if (value!.length > 120) {
                      invalidD = true;
                      return "Max input length is 120 characters.";
                    } else {
                      invalidD = false;
                      return null;
                    }
                  },
                  maxLines: 5,
                  maxLength: 121,
                  decoration: InputDecoration(
                    errorStyle: ourTextStyle(color: Colors.red, fontSize: 13),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor())),
                    labelText: 'Describe your Problem here',
                    labelStyle: ourTextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Color.fromARGB(255, 216, 107, 147),
                  onPressed: () {
                    // if (textTitle.text.isEmpty) {
                    //   CoolAlert.show(
                    //     context: context,
                    //     title: "Title Empty",
                    //     type: CoolAlertType.error,
                    //     text: "Please Fill Request Title",
                    //     confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                    //   );
                    //
                    // } else
                    if (textDescription.text.isEmpty || invalidD == true) {
                      CoolAlert.show(
                        context: context,
                        title: "Description is invalid",
                        type: CoolAlertType.error,
                        text: "Please enter a valid Request Description",
                        confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                      );
                    } else if (textTitle.text.isEmpty || invalidT == true) {
                      CoolAlert.show(
                        context: context,
                        title: "Title is not valid",
                        type: CoolAlertType.error,
                        text: "Please enter a valid Request title",
                        confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                      );
                    } else {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          text: 'Are you sure you want to submit this request?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'Cancel',
                          confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                          title: "Submit Request",
                          onCancelBtnTap: () {
                            Navigator.of(context).pop(true);
                          },
                          onConfirmBtnTap: () async {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.loading,
                              text: "Loading",
                            );

                            await addRequest();

                            textDescription.clear();
                            textTitle.clear();

                            CoolAlert.show(
                              title: "Success",
                              context: context,
                              type: CoolAlertType.success,
                              text: "Request submitted successfully!",
                              confirmBtnColor:
                                  Color.fromARGB(255, 216, 107, 147),
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop(true);
                              },
                            );
                          });
                    }
                  },
                  child: Text(
                    "Submit Request",
                    style: ourTextStyle(
                      color: Colors.white, //Colors.orange,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                              isManger: false,
                              ticket: ticket,
                            )),
                  );
                },
                child: Row(
                  children: [
                    Padding(
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
                            child: Text("Request Status : ${ticket.status}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ourTextStyle(
                                    color: button_color,
                                    fontSize: heightM * 0.4)),
                          ),
                        ],
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

  Widget buildContainerCardViewCompletedNew(TicketSupport ticket) {
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
                              isManger: false,
                              ticket: ticket,
                            )),
                  );
                },
                child: Row(
                  children: [
                    Padding(
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
                            child: Text("Request Status : ${ticket.status}",
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

  Color button_color = Color.fromARGB(255, 216, 107, 147);

  Future<bool> addRequest() async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore.collection("users_requests").add({
      'request_id': '',
      'UID': '${user?.uid}',
      'user_name': '${ourUser!.name ?? ""}',
      'request_title': "",
      'request_text': textDescription.text,
      "status": "In Progress",
      'request_date_time': DateTime.now(),
      'request_answer': "",
      'answer_date_time': DateTime.now(),
    }).then((value) async {
      await _firestore
          .collection("users_requests")
          .doc(value.id)
          .update({"request_id": value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Stream<List<TicketSupport>> getRequest() {
    return FirebaseFirestore.instance
        .collection('users_requests')
        .where("UID", isEqualTo: '${user?.uid}')
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

  Color mainColor() => const Color(0xFF5a3769);
}
