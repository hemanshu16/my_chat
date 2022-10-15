

import 'package:shared_preferences/shared_preferences.dart';

class localStorage{
  static late SharedPreferences prefs ;
  
  static Future initState() async{
     prefs = await SharedPreferences.getInstance();
  }

  static String getuserid() {
    
    String userid = prefs.getString('phonenumber') ?? "";
    return userid;
  }

  static Future cleardata() async {
    await prefs.clear();
  }
}