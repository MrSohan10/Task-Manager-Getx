import 'package:get/get.dart';

import '../../data/model/receive_mail_otp.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class PinVerifyController extends GetxController{
  bool _inProgress = false;
  String _failedMessage = '';

  bool get inProgress => _inProgress;
  String get failedMessage => _failedMessage;
  ReceiveMailAndOtp receiveOtp = ReceiveMailAndOtp();


  Future<bool> verifyPin(pin) async {
    bool isSuccess = false;
    _inProgress = true;
   update();

    final NetworkResponse response = await NetworkCaller().getRequest(
        Urls.verifyPin(ReceiveMailAndOtp.mail, pin));
    _inProgress = false;
     update();

    if (response.isSuccess && response.jsonResponse['status'] == 'success') {
      receiveOtp.receiveOtp(pin);
      isSuccess = true;
       update();
    } else {
        _failedMessage = 'invalid pin! please try again';
    }
    return isSuccess;
  }
}
