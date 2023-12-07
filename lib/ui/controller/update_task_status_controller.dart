
import 'package:get/get.dart';
import '../../data/network_caller.dart';
import '../../data/utility.dart';

class UpdateTaskStatusController extends GetxController{


  Future<void> updateTaskStatus(status, statusChange, task) async {
    final response = await NetworkCaller()
        .getRequest(Urls.updateTaskStatus(task.sId.toString(), status));
    if (response.isSuccess) {
      statusChange();
    }
  }
}