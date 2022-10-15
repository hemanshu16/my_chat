import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';
import '../widgets/conversationList.dart..dart';

class chatUserList extends StatefulWidget {
  const chatUserList({super.key});

  @override
  State<chatUserList> createState() => _chatUserListState();
}

class _chatUserListState extends State<chatUserList> {
  @override
  Widget build(BuildContext context) {
     
     
     return Scaffold(body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc('+917202959020').collection('+917202959020').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) => Container(
                child: Text("hello"),
             /* child: ConversationList(
                  name: "name",
                  messageText: "message",
                  imageUrl: "assets/images/user.png",
                  time: "current time",
                  isMessageRead: (index == 0 || index == 1)?true:false,
                ),*/
            ),
          );
        }, 
      ));
     /*StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc('+917202959020').snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading");
        }
         DocumentSnapshot document  = (snapshot.data! as dynamic);
         
         User user = User.fromSnap(document);
         if(user.friends.length == 0)
         {
           return Container(
            height: 150,
            child: Center(child: Text("No Friends",style: TextStyle(color: Colors.black,fontSize: 25),)));
         }
         
        return  ListView.builder(
              itemCount: user.friends.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
             return ConversationList(
                  name: user.friends[index].toString(),
                  messageText: user.friends[index].toString(),
                  imageUrl: "assets/images/user.png",
                  time: "current time",
                  isMessageRead: (index == 0 || index == 1)?true:false,
                );
                
              },
            );
      }
  );  */
  }
}