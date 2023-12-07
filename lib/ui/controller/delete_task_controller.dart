import 'package:get/get.dart';

import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';

class DeleteTaskController extends GetxController{

  Future<void> deleteTask(task,onDelete) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(task.sId));
    if (response.isSuccess) {
      onDelete();
    }
  }
}