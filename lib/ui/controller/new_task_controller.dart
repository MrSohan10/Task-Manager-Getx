import 'package:get/get.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class NewTaskController extends GetxController {
  TaskListModel _taskListModel = TaskListModel();
  bool _taskListProgress = false;

  TaskListModel get taskListModel => _taskListModel;

  bool get taskListProgress => _taskListProgress;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _taskListProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTaskList);
    _taskListProgress = false;
    update();
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
      update();
    }
    return isSuccess;
  }
}
