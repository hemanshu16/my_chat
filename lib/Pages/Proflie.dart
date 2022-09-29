import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/Pages/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String image_url = "";
  var is_image = false;
  var is_image_selected = false;
  var imageupload = "";
  final usernamecontroller = TextEditingController();
  final userdescription = TextEditingController();

  late PlatformFile file;
  Future<String> getuserid() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = await prefs.getString('phonenumber') ?? "";
    return userid;
  }

  Future cleardata() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future uploadFile() async {
    String path = file.path ?? "null";
    if (path != "null") {
      File file1 = File(path);
      String filename = await getuserid();
      final ref =
          FirebaseStorage.instance.ref().child('Profile_Imgages/${filename}');

      UploadTask uploadTask = ref.putFile(file1);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      final docRef = FirebaseFirestore.instance.collection("users");

      docRef.doc(filename).update({"url": url}).then((value) => {});

      if (path != "null") {
        setState(() {
          image_url = url;
          is_image = true;
          imageupload = "";
        });
      }
    }
  }

  Future savrUserChanges(String name, String desc) async {
    String userid = await getuserid();
    final docRef = FirebaseFirestore.instance.collection("users");
    docRef
        .doc(userid)
        .update({"name": name, "about": desc}).then((value) => {});
  }

  Future getUserData() async {
    String userid = await getuserid();
    final docRef = FirebaseFirestore.instance.collection("users");

    docRef.doc(userid).get().then(
      (DocumentSnapshot doc) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          usernamecontroller.text = data['name'];
          userdescription.text = data['about'];
          setState(() {
            image_url = data['url'];
            is_image = true;
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: new Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            "My Chat",
            style: TextStyle(fontSize: 22),
          ),
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
              // Navigator.pushNamed(context,"/Profile");
            },
          )
        ],
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
                    child: is_image
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(image_url),
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
                Positioned(
                    bottom: 150.0,
                    right: 38.5,
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.blueAccent,
                        size: 50,
                      ),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: true,
                          allowedExtensions: ['jpg', 'pdf', 'doc'],
                        );

                        if (result != null) {
                          file = result.files.first;
                          is_image_selected = true;
                        }
                      },
                    )),
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
            TextField(
              controller: usernamecontroller,
              decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            SizedBox(height: 40),
            Text(
              'About Your Self',
              style: TextStyle(
                color: Colors.grey[800],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: userdescription,
              decoration: InputDecoration(
                  hintText: "About Your Self",
                  prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    if (is_image_selected) {
                      setState(() {
                        imageupload = "Image is uploading ....";
                      });
                      uploadFile();
                      is_image_selected = false;
                    }
                    savrUserChanges(
                        usernamecontroller.text, userdescription.text);
                  },
                  heroTag: "btn1",
                  label: const Text('Save'),
                  icon: const Icon(Icons.upload),
                  backgroundColor: Colors.blue,
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    print(await getuserid());
                    await cleardata();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyPhone()),
                        (Route route) => false);
                  },
                  heroTag: "btn2",
                  label: const Text('Log Out'),
                  icon: const Icon(Icons.logout),
                  backgroundColor: Colors.blue,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  imageupload,
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontSize: 16.0,
                    letterSpacing: 1.5,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
