import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String about;
  final List friends;
  final String name;
  final String url;
  final String status;

  const User(
      {required this.about,
      required this.friends,
      required this.name,
      required this.url,
      required this.status
      });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      about: snapshot["about"],
      friends : snapshot["friends"] ?? "-1",
      name: snapshot["name"],
      url: snapshot["url"],
      status : snapshot["status"]
    );
  }

   Map<String, dynamic> toJson() => {
        "about": about,
        "friends": friends,
        "name": name,
        "url": url,
        "status" : status
      };
}