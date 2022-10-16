import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:my_chat/Services/contactlist.dart';
import 'package:my_chat/Services/localstorage.dart';
import '../widgets/conversationList.dart..dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String userid = "";
  bool isuser = false;
  bool isfriendfound = false;
  bool ismessage = false;
  String message = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
  }

  void getuser()  {
    userid = localStorage.getuserid();
    setState(() {
      isuser = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(children: [
                        FloatingActionButton.extended(
                          onPressed: () async {
                            final FlutterContactPicker contactPicker =
                                FlutterContactPicker();
                            Contact? contact =
                                await contactPicker.selectContact();
                            if (contact != null) {
                              String number = contact.phoneNumbers.toString();
                              int n = number.length;
                              number = number.substring(1, n - 1);
                              number = number.trim();
                              if (number[0] == '+') {
                                number = number.substring(3);
                              }
                              number = number.replaceAll(' ', '');
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(number)
                                  .get()
                                  .then(
                                (DocumentSnapshot doc) {
                                  if (doc.data() != null) {
                                    crudcontactlist.add_contact(number);
                                  } else {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Selected Friend does not have account"),
                                      action: SnackBarAction(
                                        label: 'close',
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: const Text("Add New",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                          backgroundColor: Colors.pink[50],
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                onChanged: (String number){
                  
                  FirebaseFirestore.instance.collection("users").doc(number).get().then(
                  (DocumentSnapshot doc) {
                    if (doc.data() != null) {
                    
                           final snackBar = SnackBar(
                            duration: const Duration(seconds: 20),
                            content: const Text('Friend also Using mychat'),
                            action: SnackBarAction(
                            label: 'add',
                            onPressed: () {
                                 crudcontactlist.add_contact(number);
                                 final snackBar = SnackBar(
                                  duration: const Duration(seconds: 20),
                                  content: const Text('Friend is Added'),
                                  action: SnackBarAction(
                                  label: 'close',
                                  onPressed: () {
                                      
                                  },
                                ),
                                );
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                          ),
                          );
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        
                    }
                    else{
                        final snackBar = SnackBar(
                            content: const Text('Friend Not Found'),
                            action: SnackBarAction(
                            label: 'close',
                            onPressed: () {
                            },
                          ),
                          );
                            ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
      
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            isuser
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(userid)
                        .collection("Friends")
                        .orderBy("timesent", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      if (snapshot.data!.size == 0) {
                        return const Text(
                          "No Friends",
                          style: TextStyle(color: Colors.black),
                        );
                      }

                      // return Container();
                      return ListView(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          var arr = data['timesent'].toString().split("=");
                          int length = arr.length;
                          String currenttime = "";

                          int time = 0;
                          if (length == 3) {
                            String time = arr[1];
                            time = time.split(",")[0];

                            int seconds = int.parse(time);
                            final DateTime date1 =
                                DateTime.fromMillisecondsSinceEpoch(
                                    seconds * 1000);
                            currenttime = DateFormat.jm().format(date1);
                          }

                          return ConversationList(
                              name: data['contactId'],
                              messageText: data['lastMessage'],
                              imageUrl: "",
                              time: currenttime,
                              isMessageRead: false);
                        }).toList(),
                      );
                    },
                  )
                : const Text(
                    "Loading",
                    style: TextStyle(color: Colors.black),
                  ),
          ],
        ),
      ),
    );
  }
}
