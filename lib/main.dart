import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/Services/localstorage.dart';
import 'Pages/Proflie.dart';
import 'Pages/Register.dart';
import 'Pages/home.dart';
import 'Pages/otheruserprofile.dart';
import 'Pages/verify.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await localStorage.initState();
  
  final String action = localStorage.getuserid();
  String initialroute = "/phone";

  if(action != "")   // here always use "" becaluse if use null then action can't always be null
  {
    initialroute = "/home" ;
  }
  runApp(MaterialApp(initialRoute: initialroute,
   routes: {
     '/phone': (context) => const MyPhone(),
    '/verify': (context) => const MyVerify(),
    '/home' : (context) => const Home(),
    '/Profile' :(context) => const Profile(),
    '/FriendsProfile' :(context) =>  FriendsProfile(),
    
  }));
}
