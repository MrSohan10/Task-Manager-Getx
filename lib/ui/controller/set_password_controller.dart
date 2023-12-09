import 'package:get/get.dart';

import '../../data/model/receive_mail_otp.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class SetPasswordController extends GetxController {
  bool _inProgress = false;
  String _message = '';
  String _failedMessage = '';

  bool get inProgress => _inProgress;

  String get message => _message;

  String get failedMessage => _failedMessage;

  Future<bool> resetPassword(password) async {
    _inProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.resetPass, body: {
      "email": ReceiveMailAndOtp.mail,
      "OTP": ReceiveMailAndOtp.otp,
      "password": password
    });
    _inProgress = false;
    update();

    if (response.isSuccess) {
      _message = 'Password change successfully! please Login';
      return true;
    } else {
      _failedMessage = 'Something is wrong! please try again';
    }
    return false;
  }
}
