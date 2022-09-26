import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Proflie.dart';
import 'Pages/Register.dart';
import 'Pages/home.dart';
import 'Pages/verify.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final String? action = prefs.getString('credentail');
  String initialroute = "/phone";
  print(action);
  if(action != null)
  {
    initialroute = "/home" ;
  }
  runApp(MaterialApp(initialRoute: initialroute,
   routes: {
     '/phone': (context) => MyPhone(),
    '/verify': (context) => MyVerify(),
    '/home' : (context) => Home(),
    '/Profile' :(context) => Profile() ,
  }));
}
