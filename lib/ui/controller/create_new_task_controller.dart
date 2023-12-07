import 'package:get/get.dart';
import 'package:task_manager/ui/controller/task_count_controller.dart';

import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';
import 'new_task_controller.dart';

class CreateNewTaskController extends GetxController {
  bool _inProgress = false;
  String _message = '';
  String _failedMessage = '';

  bool get inProgress => _inProgress;

  String get message => _message;

  String get failedMessage => _failedMessage;

  Future<bool> createTask(title, description) async {
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.createNewTask,
        body: {"title": title, "description": description, "status": "New"});
    _inProgress = false;
    update();

    if (response.isSuccess) {
      Get.find<NewTaskController>().getNewTaskList();
      Get.find<TaskCountController>().getTaskCount();
      _message = 'New Task add Successfully!';
      return true;
    } else {
      _failedMessage = 'Task create failed! please try again';
    }
    return false;
  }
}
