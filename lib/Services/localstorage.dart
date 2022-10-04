

import 'package:shared_preferences/shared_preferences.dart';

class localStorage{

  Future<String> getuserid() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = await prefs.getString('phonenumber') ?? "";
    return userid;
  }

  Future cleardata() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}