import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Pages/Register.dart';
import 'Pages/verify.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(initialRoute: '/phone',
   routes: {
     '/phone': (context) => MyPhone(),
    '/verify': (context) => MyVerify(),
  }));
}
