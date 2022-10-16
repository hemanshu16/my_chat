import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/Services/localstorage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/messagecrud.dart';

class chatmessages extends StatefulWidget {
  late String friendId;
  late String userId;
  late String roomId;
  chatmessages({required this.friendId}) {
    userId = localStorage.getuserid();
    int user = int.parse(userId);
    int friend = int.parse(friendId);
    if (user > friend) {
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
  var messages = MessageCrud();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
       scrolldown();
       print("scroll down not ahapped");
    });
        
  }
  final ScrollController _controller = ScrollController();
  void scrolldown()
  {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }
  @override
  Widget build(BuildContext context) {
    

    return SingleChildScrollView(
        
        controller: _controller,
        physics: const ScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.roomId)
              .orderBy('timesent', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            if (snapshot.data!.size == 0) {
              return const Text(
                "No Conversation Yet Done",
                style: TextStyle(color: Colors.black),
              );
            }
             
            // return Container();
            return ListView(
              shrinkWrap: true,
              reverse: true,
              physics: const ScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                String documentid = document.id;
               

                /// Time Format Code
                var arr = data['timesent'].toString().split("=");
                int length = arr.length;
                String currenttime = "";
                int time = 0;
                if (length == 3) {
                  String time = arr[1];
                  time = time.split(",")[0];

                  int seconds = int.parse(time);
                  final DateTime date1 =
                      DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
                  currenttime = "${DateFormat.jm().format(date1)} ${DateFormat.yMd().format(date1)}";
                }

                //
                Column meswidget;
                if (data['type'] == 'jpg' ||
                    data['type'] == 'jpeg' ||
                    data['type'] == 'png' ||
                    data['type'] == 'gif') {
                  meswidget = Column(
                    children: [
                      Image.network(data['url']),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: data['senderId'] == widget.userId
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Text(currenttime),
                      ),
                    ],
                  );
                } else {
                  meswidget = Column(
                    children: [
                      Text(data['text']),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        currenttime,
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  );
                }
               
                EdgeInsets paddings;
                Color? color;
                if (data['type'] == 'png' ||
                    data['type'] == 'jpg' ||
                    data['type'] == 'jpeg' ||
                    data['type'] == 'gif') {
                  color = Colors.white;
                  if (data['senderId'] == widget.userId) {
                    paddings = const EdgeInsets.fromLTRB(40, 0, 0, 0);
                  } else {
                    paddings = const EdgeInsets.fromLTRB(0, 0, 40, 0);
                  }
                } else {
                  paddings = const EdgeInsets.all(16);
                  if (data['senderId'] == widget.userId) {
                    color = Colors.blue[200];
                  } else {
                    color = Colors.grey.shade200;
                  }
                }
                return GestureDetector(
                  onLongPress: () {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.blue[50],
                      content: Text(data['text'],style: const TextStyle(color: Colors.blue),),
                      action: SnackBarAction(
                        label: 'Delete',
                        onPressed: () {
                          scrolldown();
                          messages.deleteMessage(widget.roomId, documentid,
                              data['text'], data['type']);
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  onTap: () async {
                    if (data['url'] != "") {
                      if (!await launch(data['url'])) {
                        print("erroor");
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (data['senderId'] == widget.userId
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: data['type'] == 'png' ||
                                    data['type'] == 'jpg' ||
                                    data['type'] == 'jpeg'
                                ? BorderRadius.circular(0)
                                : BorderRadius.circular(20),
                            color: color,
                          ),
                          padding: paddings,
                          child: meswidget),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
