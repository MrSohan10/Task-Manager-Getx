import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/user_model.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _updateInProgress = false;
  String _message = "";
  String _failedMessage = "";
  XFile? _photo;
  bool get updateInProgress => _updateInProgress;
  String get message => _message;
  String get failedMessage => _failedMessage;
  XFile? get photo => _photo;

  receiveImage (image){
    _photo = image;
    update();
  }
  Future<bool> updateProfile(
      email, firstName, lastName, mobile, password,) async {
    _updateInProgress = true;
    update();
    String? photoInBase64;

    Map<String, dynamic> inputData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };
    if (password.isNotEmpty) {
      inputData["password"] = password;
    }
    if (_photo != null) {
      List<int> imageBytes = await _photo!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData["photo"] = photoInBase64;
    }
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.updateProfile, body: inputData);
    _updateInProgress = false;
    update();
    if (response.isSuccess) {
          Get.find<AuthController>().updateInformation(UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          mobile: mobile,
          photo: photoInBase64 ?? Get.find<AuthController>().user?.photo));
      _message = "Update profile Success!";
      return true;
    } else {
      _failedMessage = "Update failed! please try again.";
    }
    return false;
  }
}
