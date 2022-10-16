import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Pages/chatDetailPage.dart';

class ConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl = "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png";
  String time;
  String old_message = "";
  bool data = false;
  bool isMessageRead;
  String id = "";
  ConversationList({required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead}){
             id = name;
             if(messageText.length > 35)
             {
              messageText = messageText.substring(0,35) ;
              messageText = "$messageText...";
             }
  }
  @override
  _ConversationListState createState() => _ConversationListState();
   
}  

class _ConversationListState extends State<ConversationList> {
    
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection("users").doc(widget.name).get().then(
      (DocumentSnapshot doc) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
         
          setState(() {
            widget.imageUrl = data['url'];   
            widget.name = data['name'];
            widget.data = true;
            
            print(widget.imageUrl);
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatDetailPage(friendId:widget.id);
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widget.data ?  CircleAvatar(
                            backgroundImage: NetworkImage(widget.imageUrl),
                            radius: 25,
                          )
                        : const CircleAvatar(
                            // backgroundImage: AssetImage('images/first.jpg'),
                            radius: 25,
                          ),
                  
                 
                  const SizedBox(width: 8,), 
                  Expanded(
                    child: Container(
                      height: 60,
                      width : 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              const SizedBox(width: 8,),
                              Text(widget.name, style: const TextStyle(fontSize: 16,color: Color.fromARGB(255, 0, 0, 0)), ),
                            ],
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            children: [
                              const SizedBox(width: 8,),
                              Text(widget.messageText,style: TextStyle(fontSize: 13,color: const Color.fromARGB(255, 233, 77, 129), fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
               decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
              height: 60,
              child: Row(
                children: [
                  Center(child: Text(widget.time,style: TextStyle(fontSize: 12 , fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),)),
                  const SizedBox(width: 5,)
                ],
              )),
              
          ],
        ),
      ),
    );
  }
}

