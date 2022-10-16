import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/Pages/home.dart';
class FriendsProfile extends StatefulWidget {
 
  String friendId = "";
  String UserId = "";
  String friendname = "";
  String friendabout = "";
  String imageurl = "";
   @override
  State<FriendsProfile> createState() => _FriendsProfileState();
}

class _FriendsProfileState extends State<FriendsProfile> {
 
 
  void getUserData() {
   
    final docRef = FirebaseFirestore.instance.collection("users");

    docRef.doc(widget.friendId).get().then(
      (DocumentSnapshot doc) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
         
          setState(() {
            widget.friendname = data['name'];
            widget.friendabout = data['about'];
            widget.imageurl = data['url'];
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(widget.friendId == ""){
    var data =  ModalRoute.of(context)!.settings.arguments as Map<String,dynamic> ;
    widget.friendId = data['friendid'];
    widget.UserId = data['userid'];
    getUserData();
    }
    
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: new Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            "Friend",
            style: TextStyle(fontSize: 22),
          ),
        ),
        automaticallyImplyLeading: false,
       
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                //first child
                Container(
                  width: 350.0,
                  height: 350.0,
                  child: Center(
                    child: widget.imageurl != ""
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(widget.imageurl),
                            radius: 125,
                          )
                        : CircleAvatar(
                            // backgroundImage: AssetImage('images/first.jpg'),
                            radius: 100,
                          ),
                  ),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ), //second child
               
              ],
            ),
            Text(
              'NAME: ',
              style: TextStyle(
                color: Colors.grey[900],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10),
            Text(widget.friendname),
            SizedBox(height: 40),
            Text(
              'About Friend',
              style: TextStyle(
                color: Colors.grey[800],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10),
            Text(widget.friendabout),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                  onPressed: () async {
                      FirebaseFirestore.instance.collection("users").doc(widget.UserId).collection("Friends")
                      .doc(widget.friendId).delete();
                      int user = int.parse(widget.UserId);
                      int friend = int.parse(widget.friendId);
                      if (user > friend) {
                        int temp = user;
                        user = friend;
                        friend = temp;
                      }
                      String roomid = user.toString() + friend.toString();
                      var collection = FirebaseFirestore.instance.collection(roomid);
                      var snapshots = await collection.get();
                      for (var doc in snapshots.docs) {
                        await doc.reference.delete();
                      }
                       Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Home()),
                        (Route route) => false);
                  },
                  heroTag: "btn1",
                  label: const Text('Remove From Friends'),
                  icon: const Icon(Icons.delete),
                  backgroundColor: Colors.blue,
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  heroTag: "btn2",
                  label: const Text('Back'),
                  icon: const Icon(Icons.logout),
                  backgroundColor: Colors.blue,
                )
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}