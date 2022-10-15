import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/models/chatMessageModel.dart';
import 'package:my_chat/Services/localstorage.dart';
import 'package:intl/intl.dart';
class chatmessages extends StatefulWidget {
 
  late String friendId;
  late String userId;
  late String roomId;
  chatmessages({required this.friendId})
  {
       userId = localStorage.getuserid();
       int user = int.parse(userId);
       int friend = int.parse(friendId);
       if(user > friend)
       {
          int temp = user;
          user = friend;
          friend = temp;
       }
       roomId = user.toString() + friendId.toString();
       print(roomId);
  }
 
  @override
  State<chatmessages> createState() => _chatmessagesState();
}

class _chatmessagesState extends State<chatmessages> {
   List<Message> messages = [];
  
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    
    return  SingleChildScrollView(
         controller: _controller,
        physics: ScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(widget.roomId)
                        .orderBy('timesent',descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      if (snapshot.data!.size == 0) {
                        return Text(
                          "No Conversation Yet Done",
                          style: TextStyle(color: Colors.black),
                        );
                      }

                      // return Container();
                      return ListView(
                       
                        shrinkWrap: true,
                        reverse: true,  
                        physics: ScrollPhysics(), 
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                       _controller.jumpTo(_controller.position.maxScrollExtent);
                        //Message msg = Message.fromMap(data);
                          var arr = data['timesent'].toString().split("=");
                          // String time = arr[3];
                          // time  = time.substring(0,time.length-1);
                          int length = arr.length;
                          String currenttime = "";
                          int time = 0;
                          if (length == 3) {
                            String time = arr[2];
                            int seconds =
                                int.parse(time.substring(0, time.length - 2));
                            final DateTime date1 =
                                DateTime.fromMillisecondsSinceEpoch(
                                    seconds * 1000);
                            currenttime = DateFormat.jm().format(date1);
                            currenttime = DateFormat.MEd().format(date1) +" " +  currenttime;
                          }
                         var meswidget ;
                         if(data['type'] == 'image' || data['type'] == 'gif')
                         {
                           meswidget = Image.network(data['url']);
                           
                         }
                         else if(data['type'] == 'text')
                         {
                          meswidget = Column(
                            children: [
                              Text(data['text']),
                              SizedBox(height: 10,),
                              Text(currenttime,style: TextStyle(color: Colors.black),)
                            ],
                          );
                         }
                         var paddings ;
                         var color;
                         if(data['type'] != 'text')
                         {  color = Colors.white;
                            if(data['senderId'] == widget.userId)
                            {
                               paddings = EdgeInsets.fromLTRB(30, 0, 0, 0);
                               
                            }
                            else{
                              paddings = EdgeInsets.fromLTRB(0, 0, 30, 0);
                            }
                         }
                         else{
                          paddings = EdgeInsets.all(16);
                          if(data['senderId'] == widget.userId)
                            {
                              color = Colors.blue[200];
                               
                            }
                            else{
                              color = Colors.grey.shade200;
                            }
                          

                         }

                        return Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment:
                                (data['senderId'] == widget.userId
                                    ? Alignment.topRight
                                    : Alignment.topLeft),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: data['type'] == 'text' ? BorderRadius.circular(20) : BorderRadius.circular(0),
                                color:color,
                                    
                              ),
                              padding: paddings,
                              child:  meswidget
                            ),
                          ),
                        );
        
      
                        }).toList(),
                      );
                    },
                  )
      );
  }
}