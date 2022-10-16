

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chat/Services/localstorage.dart';

class crudcontactlist{

  static String getuserid()  {
    
    String userid = localStorage.getuserid();
    return userid;
  }

  static void add_contact(String number) async
   {
      
       String userid =  getuserid();
       final docRef = FirebaseFirestore.instance.collection("users").doc(userid).collection("Friends");
       docRef.doc(number).set({"contactId":number,"timesent":"","lastMessage" : "",});
       final docRef1 = FirebaseFirestore.instance.collection("users").doc(number).collection("Friends");
       docRef1.doc(userid).set({"contactId":userid,"timesent":"","lastMessage" : "",});
       
     //  docRef.update({"friends":FieldValue.arrayRemove([number])});
   }

   static Future<String> get_contact() async{
           String userid = getuserid();
    final docRef = FirebaseFirestore.instance.collection("users");

    docRef.doc(userid).get().then(
      (DocumentSnapshot doc) {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
         // print(data["friends"] as []);
          return data["friends"];
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return "NOt found";
   }
  
   
}