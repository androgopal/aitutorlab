
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../ui/home/Dashboard.dart';



class SessionManager {
  static SharedPreferences? prefs;
  static Future init() async => prefs = await SharedPreferences.getInstance();
  String user_token = "";
  String user_fname = "";
  String user_lname = "";
  String user_email = "";
  String user_phone = "";
  String user_dob = "";
  String user_id = "";
  bool IsLoggedIn = true;
  bool isAppDarkThem = false;

  Future<void> saveUserData(Map userData) async {
    Map studentData = userData;

    user_token = studentData['user_token'].toString() ?? '';
    user_id = studentData['user_id'].toString() ?? '';
    user_fname = studentData['user_fname'].toString() ?? '';
    user_lname = studentData['user_lname'].toString() ?? '';
    user_email = studentData['user_email'].toString() ?? '';
    user_phone = studentData['user_mobile'].toString() ?? '';
    user_dob = studentData['user_dob'].toString() ?? '';

    if (kDebugMode) {
      print("abc ${user_token.toString()}");
    }
    prefs?.setString('user_token', user_token);
    prefs?.setBool('IsLoggedIn', IsLoggedIn);

    if (kDebugMode) {
      print("def ${user_token.toString()}");
    }
    Get.offAll(() => Dashboard(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
  }



  static String? getTokenId() => prefs!.getString("user_token") ?? '';
  static String? getUserId() => prefs!.getString("user_id") ?? '';
  static String? getUserFname() => prefs!.getString("user_fname") ?? '';
  static String? getUserLname() => prefs!.getString("user_lname") ?? '';
  static String? getUserName() => "${prefs!.getString("user_fname") ?? ''} ${prefs!.getString("user_lname") ?? ''}";
  static String? getUserEmail() => prefs!.getString("user_email") ?? '';
  static String? getUserPhone() => prefs!.getString("user_phone") ?? '';
  static String? getUserDob() => prefs!.getString("user_dob") ?? '';
  static bool? isLogin() => prefs?.getBool("IsLoggedIn") ?? false;

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Get.offAll(()=> LoginPage());
  }

  Future<void> changeAppTheme(bool isDarkThem) async {
    prefs?.setBool('isAppDarkThem', isDarkThem);
  }
  static bool? isAppDarkTheme() => prefs?.getBool("isAppDarkThem");
}