import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myProfile extends StatefulWidget {
  myProfile({Key? key}) : super(key: key);

  _myProfile createState() => _myProfile();
}

class _myProfile extends State<myProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 22,
            color: const Color(0xFF5a3769),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(
              right: 15,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: const Color(0xFF5a3769),
                        ),
                      ),
                      content: Text("Are you sure you want to logout?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            //action code for "Yes" button
                            // await FirebaseAuth.instance.signOut();
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                            // );
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xFF5a3769),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); //close Dialog
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xFF5a3769),
                            ),
                          ),
                        )
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.logout_outlined,
              color: const Color(0xFF5a3769),
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
