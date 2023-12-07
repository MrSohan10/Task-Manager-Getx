import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screen/login_screen.dart';

import 'network_response.dart';

class NetworkCaller {
  Future<NetworkResponse> postRequest(String url,
      {Map<String, dynamic>? body, bool isLogin = false}) async {
    try {
      final Response response = await post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            "Content-Type": "Application/json",
            "token": AuthController.token.toString()
          });
      if (response.statusCode == 200) {
        return NetworkResponse(
            isSuccess: true,
            jsonResponse: jsonDecode(response.body),
            statusCode: 200);
      }else if(response.statusCode==401){
        if(isLogin == false){
          backToLogin();
        }
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            jsonResponse: jsonDecode(response.body));
      }
      else {
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            jsonResponse: jsonDecode(response.body));
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<NetworkResponse> getRequest(String url,) async {
    try {
      final Response response = await get(Uri.parse(url),
          headers: {
            "Content-Type": "Application/json",
            "token": AuthController.token.toString()
          });
      if (response.statusCode == 200) {
        return NetworkResponse(
            isSuccess: true,
            jsonResponse: jsonDecode(response.body),
            statusCode: 200);
      }else if(response.statusCode==401){
        backToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            jsonResponse: jsonDecode(response.body));
      }
      else {
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            jsonResponse: jsonDecode(response.body));
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<void> backToLogin() async {
    await AuthController.clearAuthData();
    Navigator.pushAndRemoveUntil(TaskManager.navigationKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()), (
            route) => false);
  }
}
