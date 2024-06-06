import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferanceHelper {
  // that random 10 digit number
  static String userIdKey = "USERKEy";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.setString(userIdKey, getUserId);
  }

  Future<String?> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userIdKey);
  }

  // here is Username all are capitals
  static String userNamekey = "USERNAMEKEY";

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(userNamekey, getUserName.toUpperCase());
  }

  Future<String?> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString(userNamekey);
  }

  // email id is here
  static String userEmailKey = "USEREMAILKEY";

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.setString(userEmailKey, getUserEmail);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString(userEmailKey);
  }

  // Display Name is here all are in smallllllll
  static String displayNameKey = "USERDISPLAYNAME ";

  Future<bool> saveUserDisplayName(String getUserDisplayName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.setString(displayNameKey, getUserDisplayName);
  }

  Future<String?> getUserDisplayName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(displayNameKey);
  }
}
