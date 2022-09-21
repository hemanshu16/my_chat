import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final mobilenumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Navigation Exmple'),
        ),
        body: Container(
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: mobilenumber,
                  decoration: InputDecoration(
                      hintText: "Enter Your Phone Number",
                      prefixIcon: Icon(Icons.phone, color: Colors.blueAccent),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+917202959020',
                      verificationCompleted: (PhoneAuthCredential credential) {
                        print("Done");
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        print("not done");
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        print("code sent" + verificationId);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        print("time out");
                      },
                    );
                    // print(mobilenumber.text);
                    //  Navigator.pushNamed(context, '/location');
                  }, //9328527844
                  label: const Text('Send OTP'),

                  backgroundColor: Colors.pink,
                ),
              ],
            )));
  }
}
