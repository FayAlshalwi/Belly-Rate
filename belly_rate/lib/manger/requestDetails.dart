import 'package:belly_rate/models/ticketSupport.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_btn/loading_btn.dart';

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
  //double heightM = MediaQuery.of(context).size.height / 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "${widget.ticket.requestTitle}",
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
                            if (widget.isManger == true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 8.0, right: 8.0),
                                child: Text(
                                  "From",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor(),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            if (widget.isManger == true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 4, right: 8.0),
                                child: Text(
                                  "${widget.ticket.username}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: mainColor(),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 8.0, right: 8.0),
                              child: Text(
                                "Complaint Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: mainColor(),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 4, right: 8.0),
                              child: Text(
                                // "${widget.ticket!.requestText}",
                                "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(widget.ticket.requestDateTime!.millisecondsSinceEpoch))}",
                                style: TextStyle(
                                  fontSize: 16,
                                  // color: mainColor(),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 8.0, right: 8.0),
                              child: Text(
                                "Complaint description",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: mainColor(),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 4, right: 8.0),
                              child: Text(
                                // "${widget.ticket!.requestText}",
                                "${widget.ticket.requestText!.isNotEmpty ? widget.ticket.requestText : "No Subject"}",
                                style: TextStyle(
                                  fontSize: 16,
                                  // color: mainColor(),
                                  fontWeight: FontWeight.w400,
                                ),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12,
                                                  // left: 8.0,
                                                  right: 8.0),
                                              child: Text(
                                                "Answer Date",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: mainColor(),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, right: 8.0),
                                                child: Text(
                                                  "${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(widget.ticket.answerDateTime!.millisecondsSinceEpoch))}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12, right: 8.0),
                                              child: Text(
                                                "Manger Answer",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: mainColor(),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    // left: 8.0,
                                                    top: 4,
                                                    right: 8.0),
                                                child: Text(
                                                  widget.ticket.requestAnswer!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // color: mainColor(),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )),
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
                          padding: const EdgeInsets.only(
                              top: 12, left: 8.0, right: 8.0),
                          child: Text(
                            "Your Reply",
                            style: TextStyle(
                              fontSize: 16,
                              color: mainColor(),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                      if (widget.ticket.status == "In Progress" &&
                          widget.isManger == true)
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          margin: EdgeInsets.fromLTRB(5, 5, 7, 2),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.13)),
                          ),
                          child: Stack(
                              //
                              alignment: AlignmentDirectional.center,
                              //
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  controller: text,
                                  cursorColor: Colors.black,
                                  maxLines: 4,
                                  maxLength: 120,
                                  onChanged: (value) {
                                    _formtext.currentState!.validate();
                                  },
                                  validator: (value) {
                                    final RegExp regex =
                                        RegExp(r"^[a-zA-Z0-9 \n.]+$");

                                    if (value!.isEmpty) {
                                      invalid1 = true;
                                      return "Reply cant be empty";
                                    }
                                    if (!regex.hasMatch(value)) {
                                      invalid1 = true;
                                      return "special characters are not allowed";
                                    }
                                    if (value.length < 3) {
                                      invalid1 = true;
                                      return "Min input length is 3 characters.";
                                    }
                                    if (value.length > 120) {
                                      invalid1 = true;
                                      return "Max input length is 120 characters.";
                                    } else {
                                      invalid1 = false;
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
                                    hintText: "Write your reply here",
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
                        ),

                      if (widget.ticket.status == "In Progress" &&
                          widget.isManger == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              child: LoadingBtn(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 28 * 1.6,
                                color: button_color,
                                borderRadius: 10,
                                animate: true,
                                //color: Colors.green,
                                loader: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 80,
                                  height: 40,
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                child: Text("Reply",
                                    textAlign: TextAlign.center,
                                    style: getMyTextStyle(
                                        txt_color: Colors.white,
                                        fontSize: 30 * 0.6)),

                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  if (btnState == ButtonState.idle) {
                                    if (_formtext.currentState!.validate()) {
                                      startLoading();

                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          text:
                                              'Are you sure you want to reply on this request?',
                                          confirmBtnText: 'Yes',
                                          cancelBtnText: 'Cancel',
                                          confirmBtnColor: Color.fromARGB(
                                              255, 216, 107, 147),
                                          title: "Submit Reply",
                                          onCancelBtnTap: () {
                                            stopLoading();
                                            Navigator.of(context).pop(true);
                                          },
                                          onConfirmBtnTap: () async {
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
                                                  "Complaint Replied successfully!",
                                              confirmBtnColor: Color.fromARGB(
                                                  255, 216, 107, 147),
                                              onConfirmBtnTap: () {
                                                Navigator.of(context).pop(true);
                                                Navigator.of(context).pop(true);
                                                Navigator.of(context).pop(true);
                                                Navigator.of(context).pop(true);
                                              },
                                            );
                                            stopLoading();
                                          });
                                    }
                                  }
                                },
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

  TextStyle getMyTextStyle({required Color txt_color, double fontSize = 22}) {
    return GoogleFonts.cairo(
        color: txt_color, fontSize: fontSize, fontWeight: FontWeight.bold);
  }

  Color button_color = Color.fromARGB(255, 216, 107, 147);

  Color mainColor() => const Color(0xFF5a3769);
}
