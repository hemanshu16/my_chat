import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>  {

  String image_url  = "";
  var is_image = false;
  var imageupload = "";
  Future<String> getuserid() async{
   final prefs = await SharedPreferences.getInstance();
   String userid = await prefs.getString('credentail') ?? "no";
   return userid;
  }
 
   Future uploadFile(PlatformFile file) async
   {
          String path = file.path ?? "null";
          if(path != "null"){
          File file1 = File(path);
          String filename = await getuserid();
          final ref = FirebaseStorage.instance.ref().child('Profile_Imgages/${filename}');
                          
          UploadTask uploadTask = ref.putFile(file1);
          final snapshot  = await uploadTask.whenComplete((){});
          final url = await snapshot.ref.getDownloadURL();

         

          if(path != "null"){
          setState(() {
              image_url = url;
              is_image = true;
              imageupload = "";
            });
          }

          }
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
                    child:  is_image
                              ? CircleAvatar(backgroundImage: NetworkImage(image_url),radius: 125,)
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
                        setState(() {
                          imageupload = "Image is uploading ....";
                        });
                        if (result != null) {
                          uploadFile(result.files.first);
                          
                          
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
            Text(
              'Faldu Hemanshu',
              style: TextStyle(
                color: Colors.blue[900],
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'AGE',
              style: TextStyle(
                color: Colors.grey[800],
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "19",
              style: TextStyle(
                color: Colors.blue[900],
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Icon(
                  Icons.email_rounded,
                  color: Colors.deepPurple[800],
                ),
                SizedBox(width: 12.0),
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
