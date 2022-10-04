import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:my_chat/Pages/chatUserList.dart';
import 'package:my_chat/Services/contactlist.dart';
import 'package:my_chat/Services/localstorage.dart';
import '../models/chatUsersModel.dart';
import '../models/userModel.dart';
import '../widgets/conversationList.dart..dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List<ChatUsers> chatUsers = [
    ChatUsers(text: "Jane Russel", secondaryText: "Awesome Setup", image: 'assets/images/2.jpg' , time: "Now", imageURL: 'assets/images/2.jpg', messageText: '', name: ''),
     ChatUsers(text: "Glady's Murphy", secondaryText: "That's Great", image: "assets/images/2.jpg", time: "Yesterday", imageURL: '', name: '', messageText: ''),
     ChatUsers(text: "Jorge Henry", secondaryText: "Hey where are you?", image: "images/userImage3.jpeg", time: "31 Mar", messageText: '', imageURL: '', name: ''),
    // ChatUsers(text: "Philip Fox", secondaryText: "Busy! Call me in 20 mins", image: "images/userImage4.jpeg", time: "28 Mar"),
    // ChatUsers(text: "Debra Hawkins", secondaryText: "Thankyou, It's awesome", image: "images/userImage5.jpeg", time: "23 Mar"),
    // ChatUsers(text: "Jacob Pena", secondaryText: "will update you in evening", image: "images/userImage6.jpeg", time: "17 Mar"),
    // ChatUsers(text: "Andrey Jones", secondaryText: "Can you please share the file?", image: "images/userImage7.jpeg", time: "24 Feb"),
    // ChatUsers(text: "John Wick", secondaryText: "How are you?", image: "images/userImage8.jpeg", time: "18 Feb"),
  ];

  @override
  Widget build(BuildContext context) {
   // crudcontactlist.add_contact("9978351529");
  
     
   
    return Scaffold(
       
      
     
  
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations", style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        
                      ),
                      child: Row(
                        children : [
                        FloatingActionButton.extended(onPressed: () async {
            final FlutterContactPicker _contactPicker = new FlutterContactPicker();
            Contact? contact = await _contactPicker.selectContact();
            if(contact != null)
            {
             
              String number = contact.phoneNumbers.toString();
              int n = number.length;
              number = number.substring(1,n-1);
              number = number.trim();
              if(number[0] == '+')
              {
                number = number.substring(3);
              }
              number = number.replaceAll(' ', '');
              crudcontactlist.add_contact(number);
              
            }
           },
                        icon: Icon(Icons.add,color: Colors.black,),
                         label: Text("Add New",
                        style:TextStyle(fontSize: 18,color: Colors.black)),
                        backgroundColor: Colors.pink[50],
                        ),]
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search, color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ), 
          StreamBuilder<QuerySnapshot>  (
      stream: FirebaseFirestore.instance.collection("users").doc("+917202959020").collection("Friends").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)  {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
       
     

       // return Container();
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          var userdata  ;
         FirebaseFirestore.instance.collection("users").doc(data['contactId']).get().then(
      (DocumentSnapshot doc) {
        if (doc.data() != null) {
          userdata = doc.data() as Map<String, dynamic>;
          print(userdata);
        }
      },
      onError: (e) => print("Error getting document: $e"),  
    );   // String datetime = 
            return ConversationList(
                      name: data['contactId'],
                      messageText: data['lastMessage'],
                      imageUrl: "",
                      time: "data['timeSent']",
                      isMessageRead: false,
                    ) 
              ;
          }).toList(),
        );
      }, 
    ),
          /*  ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 1)?true:false,
                ); 
              },
            ),*/

          ],
        ),
      ),

    );  
   }
  }


