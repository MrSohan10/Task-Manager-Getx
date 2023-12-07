import 'package:get/get.dart';

import '../../data/model/task_count_model.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class TaskCountController extends GetxController {
  TaskCountModel _taskCountModel = TaskCountModel();
  bool _taskCountProgress = false;

  TaskCountModel get taskCountModel => _taskCountModel;
  bool get taskCountProgress => _taskCountProgress;

  Future<bool> getTaskCount() async {
    bool isSuccess = false;
    _taskCountProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskCount);
    _taskCountProgress = false;
   update();

    if (response.isSuccess) {
      _taskCountModel = TaskCountModel.fromJson(response.jsonResponse);
      isSuccess = true;
      update();
    }
    return isSuccess;
  }
}
