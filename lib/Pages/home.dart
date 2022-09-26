
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_chat/Services/authStore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context)  {
   
    return Scaffold(
      appBar : AppBar(
        title : new Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text("My Chat",style: TextStyle(fontSize: 22),),
                ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
    
    IconButton(
      icon: Icon(
        Icons.person,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () async {
         // final prefs = await SharedPreferences.getInstance();
         // final String? action = prefs.getString('credentail');
         // final success = await prefs.remove('credentail');
         // print(action);
         Navigator.pushNamed(context,"/Profile");
      },
    )
  ],
        
      ),
    );
  }
}