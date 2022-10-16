import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
class MessageCrud {
    
    var uuid;
    MessageCrud(){
     uuid = Uuid();
    }
    void sendTextMessage(String roomId, String sender, String receiver,String text)
     {      bool isSeen = false;
            String filename = uuid.v1();
             
            FirebaseFirestore.instance.collection(roomId).doc(filename).set(
              {"senderId":sender,
              "recieverId":receiver,
              "text" : text,
              "type" : "text",
              "timesent" : FieldValue.serverTimestamp(),
              "messageId": uuid.v1(),
              "isSeen": isSeen,
              "url" : ""
              }
            ); 
            FirebaseFirestore.instance.collection("users").doc(sender).collection("Friends").doc(receiver).set({
              "contactId": receiver,
              "lastMessage" : text,
              "timesent" : FieldValue.serverTimestamp(),
            });
            FirebaseFirestore.instance.collection("users").doc(receiver).collection("Friends").doc(sender).set({
              "contactId": sender,
              "lastMessage" : text,
              "timesent" : FieldValue.serverTimestamp(),
            });
            
     }
     Future<void> sendFileMessage(String roomId,String sender,String receiver,String path) async
     {
            String filename = uuid.v1();
      final ref = FirebaseStorage.instance.ref().child('${roomId}/${filename}');
      File file = File(path);
      UploadTask uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      List<String> paths = path.split("/");
      int length = paths.length;
      String name = paths[length-1];
      List<String> names = name.split(".");
      String type = names[names.length-1];
      bool isSeen = false;
      FirebaseFirestore.instance.collection(roomId).doc(filename).set(
              {"senderId":sender,
              "recieverId":receiver,
              "text" : name,
              "type" : type,
              "timesent" : FieldValue.serverTimestamp(),
              "messageId": filename,
              "isSeen": isSeen,
              "url" : url
              }
            ); 
      FirebaseFirestore.instance.collection("users").doc(sender).collection("Friends").doc(receiver).set({
              "contactId": receiver,
              "lastMessage" : name,
              "timesent" : FieldValue.serverTimestamp(),
            });
            FirebaseFirestore.instance.collection("users").doc(receiver).collection("Friends").doc(sender).set({
              "contactId": sender,
              "lastMessage" : name,
              "timesent" : FieldValue.serverTimestamp(),
            });
     }
     
     void deleteMessage(String roomId,String messageId,String name,String type)
     {
       FirebaseFirestore.instance.collection(roomId).doc(messageId).delete().then((value) {print("--done--");})
       .catchError((onerror){print("Error");});
       
       if(type != "text"){
       FirebaseStorage.instance.ref(roomId).child(messageId).delete();
       }
     }
}