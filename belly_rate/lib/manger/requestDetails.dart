import 'package:belly_rate/models/ticketSupport.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestDetails extends StatefulWidget {
  RequestDetails({Key? key, required this.ticket, this.isManger = true})
      : super(key: key);
  TicketSupport ticket;
  bool isManger;
  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  TextEditingController text = TextEditingController();
  bool invalid1 = false;
  final _formtext = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Request Details",
          style: TextStyle(
            fontSize: 22,
            color: mainColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formtext,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: mainColor(),
                    //   width: 2.0,
                    // ),
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "Title:",
                                style: ourTextStyle(
                                    color: const Color.fromARGB(
                                        255, 216, 107, 147),
                                    fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "${widget.ticket.requestTitle!.isNotEmpty ? widget.ticket.requestTitle : "No title"}",
                                style: ourTextStyle(
                                    color: mainColor(), fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "Subject:",
                                style: ourTextStyle(
                                    color: const Color.fromARGB(
                                        255, 216, 107, 147),
                                    fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                // "${widget.ticket!.requestText}",
                                "${widget.ticket.requestText!.isNotEmpty ? widget.ticket.requestText : "No Subject"}",
                                style: ourTextStyle(
                                    color: mainColor(), fontSize: 15),
                              ),
                            ),
                            if (widget.isManger == true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  "User:",
                                  style: ourTextStyle(
                                      color: const Color.fromARGB(
                                          255, 216, 107, 147),
                                      fontSize: 17),
                                ),
                              ),
                            if (widget.isManger == true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  "${widget.ticket.username}",
                                  style: ourTextStyle(
                                      color: mainColor(), fontSize: 15),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "Request Date:",
                                style: ourTextStyle(
                                    color: const Color.fromARGB(
                                        255, 216, 107, 147),
                                    fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(widget.ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                style: ourTextStyle(
                                    color: mainColor(), fontSize: 15),
                              ),
                            ),
                            if (widget.isManger != true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  "Status:",
                                  style: ourTextStyle(
                                      color: const Color.fromARGB(
                                          255, 216, 107, 147),
                                      fontSize: 17),
                                ),
                              ),
                            if (widget.isManger != true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  "${widget.ticket.status}",
                                  style: ourTextStyle(
                                      color: mainColor(), fontSize: 15),
                                ),
                              ),
                            if (widget.ticket.status != "In Progress")
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      widget.ticket.status != "In Progress"
                                          ? Radius.circular(15.0)
                                          : Radius.circular(0.0),
                                  bottomRight:
                                      widget.ticket.status != "In Progress"
                                          ? Radius.circular(15.0)
                                          : Radius.circular(0.0),
                                ),
                                child: Container(
                                  // color: Colors.cyan.withOpacity(0.2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Answer Date:",
                                              style: ourTextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 216, 107, 147),
                                                  fontSize: 17),
                                            ),
                                            Text(
                                              "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(widget.ticket.answerDateTime!.millisecondsSinceEpoch))}",
                                              style: ourTextStyle(
                                                  color: mainColor(),
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              "Manger Answer:",
                                              style: ourTextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 216, 107, 147),
                                                  fontSize: 17),
                                            ),
                                            Text(
                                              widget.ticket.requestAnswer!,
                                              style: ourTextStyle(
                                                  color: mainColor(),
                                                  fontSize: 15),
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

                      if (widget.ticket.status == "In Progress" &&
                          widget.isManger == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Please Write your Reply here:",
                              style: ourTextStyle(
                                color: mainColor(),
                                fontSize: 14.0,
                                // textAlign: TextAlign.center,
                              )),
                        ),
                      if (widget.ticket.status == "In Progress" &&
                          widget.isManger == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: text,
                            maxLines: 3,
                            onChanged: (_) {
                              _formtext.currentState!.validate();
                            },
                            validator: (value) {
                              final RegExp regex =
                                  RegExp(r"^[a-zA-Z0-9 \n.]+$");

                              // RegExp regExp = new RegExp(pattern);
                              if (value!.isEmpty) {
                                invalid1 = true;
                                return "Reply cant be empty";
                              }
                              if (!regex.hasMatch(value!)) {
                                invalid1 = true;
                                return "special characters are not allowed";
                              }
                              if (value!.length < 3) {
                                invalid1 = true;
                                return "Min input length is 3 characters.";
                              }
                              if (value!.length > 120) {
                                invalid1 = true;
                                return "Max input length is 120 characters.";
                              } else {
                                invalid1 = false;
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor())),
                              errorStyle:
                                  ourTextStyle(color: Colors.red, fontSize: 13),
                              labelText: 'Write your Reply here',
                              labelStyle: ourTextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                // textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      if (widget.ticket.status == "In Progress" &&
                          widget.isManger == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: button_color,
                                onPressed: () {
                                  if (text.text.isNotEmpty &&
                                      invalid1 == false) {
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
                                              text_m: text.text,
                                              requestId:
                                                  widget.ticket.requestId!);

                                          text.clear();

                                          CoolAlert.show(
                                            title: "Success",
                                            context: context,
                                            type: CoolAlertType.success,
                                            text:
                                                "Request Replied successfully!",
                                            confirmBtnColor: Color.fromARGB(
                                                255, 216, 107, 147),
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
                                      title: "Reply is not valid",
                                      type: CoolAlertType.error,
                                      text:
                                          "Please enter a valid Request Reply",
                                      confirmBtnColor:
                                          Color.fromARGB(255, 216, 107, 147),
                                    );
                                  }
                                },
                                child: Text(
                                  "Reply",
                                  style: ourTextStyle(
                                    color: Colors.white, //Colors.orange,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // if(widget.ticket.status == "In Progress")
                      //   ClipRRect(
                      //     borderRadius: const BorderRadius.only(
                      //       bottomLeft: Radius.circular(15.0),
                      //       bottomRight: Radius.circular(15.0),
                      //     ),
                      //     child: InkWell(
                      //       onTap: (){
                      //         ///
                      //         // _showBottomSheet(context , ticket.requestId!);
                      //       },
                      //       child: Container(
                      //         color: mainColor(),
                      //         width: 500,
                      //         child: Center(
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 "Write Your Reply",
                      //                 style: ourTextStyle(color: Colors.white, fontSize: 13),
                      //               ),
                      //             )),
                      //       ),
                      //     ),
                      //   )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      
      
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
