
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:my_chat/Pages/Proflie.dart';
import 'package:my_chat/Services/status.dart';
import 'package:my_chat/Pages/chatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_chat/Services/contactlist.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver{
  int currentIndex = 0;
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
       print("App Started");
        Status.setStatus("online");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      if(state == AppLifecycleState.resumed)
      {
         Status.setStatus("online");
      }
      else if(state == AppLifecycleState.paused)
      {
         Status.setStatus("offline");
      }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Status.setStatus("offline");
    super.dispose();
  }
  @override
  Widget build(BuildContext context)  {
    Widget widget = ChatPage();
   switch (currentIndex) {
    case 0:
      widget = ChatPage();
      break;

    case 1:
      widget = Profile();
      break;
  }
    return Scaffold(
      
      body:Container(
        child: widget
      ),
      // body: Container(
      //   child: Center(child: Text("Chat")),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        onTap: (var index){
              print(index);
              setState(() {
                currentIndex = index;
              });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
        ],
      ),
    );
   /* return Scaffold(
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
      body: Column(
        children: [
           FloatingActionButton.extended(onPressed: () async {
            final FlutterContactPicker _contactPicker = new FlutterContactPicker();
            Contact? contact = await _contactPicker.selectContact();
            if(contact != null)
            {
             
              String number = contact.phoneNumbers.toString() ;
              crudcontactlist.add_contact(number);
              
            }
           },label: const Text("Select Friend"),)
           ,
             
        ],
      ),
    );*/
  }
}