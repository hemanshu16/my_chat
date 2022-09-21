import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Pages/Register.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(initialRoute: '/home', routes: {
    '/home': (context) => Home(),
  }));
}
