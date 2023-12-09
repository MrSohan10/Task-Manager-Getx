import 'package:get/get.dart';

import '../../data/model/user_model.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  bool _loginInProgress = false;
  String _failedMessage = '';
  bool get loginInProgress => _loginInProgress;
  String get failedMessage => _failedMessage;

  Future<bool> login(email, password) async {
    _loginInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
        body: {"email": email, "password": password}, isLogin: true);
    _loginInProgress = false;
    update();
    if (response.isSuccess) {
      await Get.find<AuthController>().saveInformation(response.jsonResponse['token'],
          UserModel.fromJson(response.jsonResponse['data']));
      return true;
    } else {
      if (response.statusCode == 401) {
        _failedMessage =  "Login failed! Please check email/password";

      } else {
          _failedMessage = 'Login failed! please try again';
      }
    }
    return false;
  }
}
