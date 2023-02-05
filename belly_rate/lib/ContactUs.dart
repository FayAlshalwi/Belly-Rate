import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  TextEditingController textTitle = TextEditingController();
  TextEditingController textDescription = TextEditingController();

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
                    color: requestsIndex == 0 ? mainColor() : Colors.white,
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
                    color: requestsIndex == 1 ? mainColor() : Colors.white,
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
                              return buildInProgressCard(ticket);
                            } else {
                              return buildCompleteCard(ticket);
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
                        color: Colors.grey.withOpacity(0.4),
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
                  style: ourTextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // TextFormField(
              //   keyboardType: TextInputType.multiline,
              //   controller: textTitle,
              //   maxLines: 1,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Describe your problem',
              //     labelStyle: ourTextStyle(
              //       color: Colors.grey,
              //       fontSize: 14.0,
              //       // textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                controller: textDescription,
                maxLines: 5,
                maxLength: 120,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor())),
                  labelText: 'Write your Problem here',
                  labelStyle: ourTextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    // textAlign: TextAlign.center,
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
                    if (textDescription.text.isEmpty) {
                      CoolAlert.show(
                        context: context,
                        title: "Description Empty",
                        type: CoolAlertType.error,
                        text: "Please Fill Request Description",
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
