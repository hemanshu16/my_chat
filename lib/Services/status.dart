

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chat/Services/localstorage.dart';

class Status {
    
    static void setStatus(String status)
   {
      String userid = localStorage.getuserid();
       print(userid);
      FirebaseFirestore.instance.collection("users").doc(userid).set({"status":status},SetOptions(merge: true));
      
   }

}