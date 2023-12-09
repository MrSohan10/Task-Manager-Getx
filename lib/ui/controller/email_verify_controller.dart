import 'package:get/get.dart';

import '../../data/model/receive_mail_otp.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class EmailVerifyController extends GetxController {
  bool _inProgress = false;
  String _failedMessage = '';

  bool get inProgress => _inProgress;

  String get failedMessage => _failedMessage;
  ReceiveMailAndOtp receiveMailAddress = ReceiveMailAndOtp();

  Future<bool> verifyEmail(email) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyEmail(email));
    _inProgress = false;
    update();
    if (response.isSuccess && response.jsonResponse['status'] == 'success') {
      receiveMailAddress.receiveMail(email);
      isSuccess = true;
      update();
    } else {
      _failedMessage = 'verify failed! please try again';
    }
    return isSuccess;
  }
}
