import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class ChatAppDetailAppBar extends StatefulWidget {
   String id;
   ChatAppDetailAppBar({required this.id});
 
  @override
  State<ChatAppDetailAppBar> createState() => _ChatAppDetailAppBarState();
}

class _ChatAppDetailAppBarState extends State<ChatAppDetailAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.id).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading");
        }
         DocumentSnapshot data  = (snapshot.data! as dynamic);
         
         
        return  AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage : NetworkImage(data['url']),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(data['name'],style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text(data['status'],style: TextStyle(color: Colors.black, fontSize: 13),),
                      ],
                    ),
                  ),
                  Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        );
      }
  ); 
  }
}