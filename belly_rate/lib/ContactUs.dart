import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_btn/loading_btn.dart';
import 'auth/our_user_model.dart';
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
  Color txt_color = Color(0xFF5a3769);
  Color button_color = Color.fromARGB(255, 216, 107, 147);
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
          "Help and Support",
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
                      "New Complaint",
                      style: ourTextStyle(
                        color: requestsIndex != 0
                            ? Color(0xFF5a3769)
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
                    color: requestsIndex == 1 ? button_color : Colors.white,
                    onPressed: () {
                      setState(() {
                        requestsIndex = 1;
                      });
                    },
                    child: Text(
                      "Previous Complaints",
                      style: ourTextStyle(
                        color: requestsIndex != 1
                            ? Color(0xFF5a3769)
                            : Colors.white,
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
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _list.length,
                            itemBuilder: (BuildContext context, int index) {
                              _list.sort(
                                  (a, b) => b.status!.compareTo(a.status!));
                              TicketSupport ticket = _list[index];
                              if (ticket.status == "In Progress") {
                                return buildContainerCardViewCompletedNew(
                                    ticket);
                                // return buildInProgressCard(ticket);
                              } else {
                                return buildContainerCardViewCompletedNew(
                                    ticket);
                                // return buildCompleteCard(ticket);
                              }
                            });
                      } else {
                        return Center(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 160,
                            ),
                            Image.asset(
                              'asset/category_img/NoRequests.png',
                              height: 230,
                            ),
                            Text("No Previous Complaints",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ));
                      }
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

  Widget buildContainerCardViewCompletedNew(TicketSupport ticket) {
    final double heightM = MediaQuery.of(context).size.height / 30;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, bottom: 0.0, top: 8.0, right: 16.0),
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
                  showModalBottomSheet(
                      useRootNavigator: false,
                      isDismissible: true,
                      enableDrag: true,
                      context: context,
                      // elevation: 20,
                      isScrollControlled: false,
                      builder: (context) {
                        return Container(
                            height: 360,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
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
                                                            top: 17,
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: Text(
                                                      "Complaint description",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: mainColor(),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 4,
                                                          right: 8.0),
                                                  child: Text(
                                                    "${ticket.requestText}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      // color: mainColor(),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                if (ticket.status !=
                                                    "In Progress")
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 17,
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        "Response",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: mainColor(),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )),
                                                if (ticket.status !=
                                                    "In Progress")
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 4,
                                                            right: 8.0),
                                                    child: Text(
                                                      "${ticket.requestAnswer}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        // color: mainColor(),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Color(0xFF5a3769), width: 2)),
                        child: Center(
                          child: Text(
                            "${ticket.requestTitle!.substring(0, 1).toUpperCase()}",
                            style: ourTextStyle(
                                fontSize: 25, color: Color(0xFF5a3769)
                                // fontWeight: FontWeight.bold
                                ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, bottom: 3.0, top: 3.0, right: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                                "${ticket.requestTitle!.isNotEmpty ? ticket.requestTitle! : "No title"}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ourTextStyle(
                                    color: Color(0xFF5a3769), fontSize: 16.5)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                                "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ourTextStyle(
                                    color: Colors.grey,
                                    fontSize: heightM * 0.45)),
                          ),
                          if (ticket.status ==
                                                    "In Progress")
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text("${ticket.status}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ourTextStyle(
                                    color: Color.fromARGB(255, 216, 107, 147),
                                    fontSize: heightM * 0.45)),
                          ),
                        if (ticket.status ==
                                                    "Completed")
                           SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text("${ticket.status}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ourTextStyle(
                                    color: Color.fromARGB(255, 216, 107, 147),
                                    fontSize: heightM * 0.43)),
                           ),
                        ],
                      ),
                    ),
                    if (ticket.status ==
                                                    "In Progress")
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, bottom: 3.0, top: 3.0, right: 12.0),
                      child: Icon(Icons.access_time,
                          size: 32, color: Color.fromARGB(255, 216, 107, 147)),
                    ),
                    if (ticket.status ==
                                                    "Completed")
                                                    const Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, bottom: 3.0, top: 3.0, right: 12.0),
                      child: Icon(Icons.check_circle_outline_rounded,
                          size: 32, color: Color.fromARGB(255, 216, 107, 147)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container addNewRequest(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              "asset/category_img/cusSer.png",
              width: 230,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 273.0, top: 1.0, bottom: 0.0),
              child: Text(
                "New Complaint",
                textAlign: TextAlign.start,
                style: ourTextStyle2(txt_size: 21, txt_color: txt_color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 2.0, bottom: 1.0),
              child: Text(
                "Kindly provide a detailed description of your complaint, and our team will get back to you in as soon as possible.",
                style: ourTextStyle2(
                    txt_size: 15, txt_color: Color.fromARGB(235, 0, 0, 0)),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "Complaint Title",
                  textAlign: TextAlign.start,
                  style: ourTextStyle2(txt_color: txt_color, txt_size: 16),
                ),
              ),
            ),
            Form(
                key: _formtext,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  // width: 450,
                  height: 60,
                  // margin: EdgeInsets.fromLTRB(23, 02, 10, 10),
                  margin: EdgeInsets.fromLTRB(2, 5, 5, 2),

                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withOpacity(0.13)),
                  ),
                  child:
                      Stack(alignment: AlignmentDirectional.center, children: [
                    TextFormField(
                      controller: textTitle,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _formtext.currentState!.validate();
                      },
                      validator: (value) {
                        final RegExp regex = RegExp(r"^[a-zA-Z0-9 \n.]+$");
                        if (value == null || value.isEmpty) {
                          invalidT = true;
                          return "Please enter complaint title";
                        }
                        if (!regex.hasMatch(value)) {
                          invalidT = true;
                          return "You cannot enter special characters !@#\%^&*()";
                        }
                        if (value.length < 3) {
                          invalidT = true;
                          return "Please enter at least 3 characters";
                        }
                        if (value.length > 25) {
                          invalidT = true;
                          return "Maximum input length is 25 characters.";
                        } else {
                          invalidT = false;
                          return null;
                        }
                      },
                      maxLength: 15,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 04, left: 0),
                        hintText: "Enter complaint title",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(158, 158, 158, 1),
                            fontSize: 16),
                      ),
                    ),
                  ]),
                )),
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.fromLTRB(0, 0, 5, 2),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Text(
                  "What is your complaint?",
                  textAlign: TextAlign.start,
                  style: ourTextStyle2(txt_color: txt_color, txt_size: 16),
                ),
              ),
            ),
            Form(
                key: _formdescription,
                child: Container(
                  alignment: AlignmentDirectional.topStart,
                  margin: EdgeInsets.fromLTRB(2, 5, 5, 2),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withOpacity(0.13)),
                  ),
                  child: Stack(
                      //
                      alignment: AlignmentDirectional.center,
                      //
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: textDescription,
                          cursorColor: Colors.black,
                          maxLines: 4,
                          maxLength: 120,
                          onChanged: (value) {
                            _formdescription.currentState!.validate();
                          },
                          validator: (value) {
                            final RegExp regex = RegExp(r"^[a-zA-Z0-9 \n.]+$");

                            // RegExp regExp = new RegExp(pattern);
                            if (value == null || value.isEmpty) {
                              invalidD = true;
                              return "Please enter your complaint";
                            }
                            if (!regex.hasMatch(value)) {
                              invalidD = true;
                              return "You cannot enter special characters !@#\%^&*()";
                            }
                            if (value.length < 3) {
                              invalidD = true;
                              return "Please enter at least 3 characters";
                            }
                            if (value.length > 120) {
                              invalidD = true;
                              return "Maximum input length is 120 characters.";
                            } else {
                              invalidD = false;
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(bottom: 04, left: 0),
                            hintText: "Write your complaint here",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(158, 158, 158, 1),
                                fontSize: 14),
                            labelStyle: ourTextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ]),
                )),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                child: LoadingBtn(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: heightM * 1.5,
                  elevation: 10.0,
                  color: button_color,
                  borderRadius: 5,
                  animate: true,
                  //color: Colors.green,
                  loader: Container(
                    padding: const EdgeInsets.all(10),
                    width: 40,
                    height: 40,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  child: Text('Send Complaint',
                      textAlign: TextAlign.center,
                      style: ourTextStyle2(
                          txt_color: Colors.white, txt_size: heightM * 0.6)),

                  onTap: (startLoading, stopLoading, btnState) async {
                    
                    if (btnState == ButtonState.idle) {
                      if (_formtext.currentState!.validate() &&
                          _formdescription.currentState!.validate()) {
                            startLoading();
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            text:
                                'Are you sure you want to submit this Complaint?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'Cancel',
                            confirmBtnColor: Color.fromARGB(255, 216, 107, 147),
                            title: "Submit Complaint",
                            onCancelBtnTap: () {
                              stopLoading();
                              Navigator.of(context).pop(true);
                            },
                            onConfirmBtnTap: () async {
                              startLoading();
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
                                  stopLoading();
                                  // Navigator.of(context).pop(true);
                                },
                              );
                            });
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> addRequest() async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore.collection("users_requests").add({
      'request_id': '',
      'UID': '${user?.uid}',
      'user_name': '${ourUser!.name}',
      'request_title': textTitle.text,
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

  TextStyle ourTextStyle2(
      {required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
  }

  Color mainColor() => Color.fromARGB(249, 106, 68, 122);
}
