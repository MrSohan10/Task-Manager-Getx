import 'package:get/get.dart';

import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class SignupController extends GetxController{
  bool _signupInProgress = false;
  String _message = "";
  String _failedMessage = "";
  bool get signupInProgress=> _signupInProgress;
  String get message => _message;
  String get failedMessage => _failedMessage;

  Future<bool> signUP(mail,firstName,lastName,mobile,password) async {
    _signupInProgress = true;
    update();
      final NetworkResponse response =
      await NetworkCaller().postRequest(Urls.registration, body: {
        "email": mail,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "password": password,
        "photo": "",
      });
      _signupInProgress = false;
       update();

      if (response.isSuccess) {
       _message = 'Account has been created! please login';
        return true;
      } else {
            _failedMessage =  'Account create failed! please try again';
      }
     return false;
  }
}