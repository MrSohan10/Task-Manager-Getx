import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_model.dart';

class AuthController {
  static String? token;
  static UserModel? user;

  static Future<void> saveInformation(String t, UserModel model) async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.setString('token', t);
   await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    token = t;
    user = model;
  }
  static Future<void> updateInformation(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    user = model;
  }

  static Future<void> initUserCache() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    user = UserModel.fromJson(jsonDecode(sharedPreferences.getString('user')?? '{}'));
  }

  static Future<bool> checkAuthState()async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey('token')){
      await initUserCache();
      return true;
    }
    return false;
  }

  static Future<void> clearAuthData() async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;

  }
}
