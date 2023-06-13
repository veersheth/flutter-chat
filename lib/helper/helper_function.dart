import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "NAMEKEY";
  static String userEmailKey = "EMAILKEY";

  //saving data to shared preferences

  //getting data from shared preferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.getBool(userLoggedInKey);
  }
}
