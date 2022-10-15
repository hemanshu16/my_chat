import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
class MessageCrud {
    
    var uuid;
    MessageCrud(){
     uuid = Uuid();
    }
    void sendTextMessage(String roomId, String sender, String receiver,String text)
     {      bool isSeen = false;
            FirebaseFirestore.instance.collection(roomId).add(
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
            
     }
     Future<bool> sendFileMessage(String roomId,String sender,String receiver,String path,String type) async
     {
            String filename = uuid.v1();
      final ref = FirebaseStorage.instance.ref().child('${roomId}/${filename}');
      File file = File(path);
      UploadTask uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
       bool isSeen = false;
      FirebaseFirestore.instance.collection(roomId).add(
              {"senderId":sender,
              "recieverId":receiver,
              "text" : "-file",
              "type" : type,
              "timesent" : FieldValue.serverTimestamp(),
              "messageId": filename,
              "isSeen": isSeen,
              "url" : url
              }
            ); 
      return true;
     }

}