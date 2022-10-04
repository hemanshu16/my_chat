

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class crudcontactlist{

  static Future<String> getuserid() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = await prefs.getString('phonenumber') ?? "";
    return userid;
  }

  static void add_contact(String number) async
   {
       print(get_contact());
       String userid = await getuserid();
       final docRef = FirebaseFirestore.instance.collection("users").doc(userid).collection("Friends");
       docRef.doc(number).set({"contactId":number,"timeSent":"","lastMessage" : "",});
       
     //  docRef.update({"friends":FieldValue.arrayRemove([number])});
   }

   static Future<String> get_contact() async{
           String userid = await getuserid();
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