import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_model.dart';

import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';
import '../widget/profile_summary.dart';
import '../widget/task_item_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  TaskListModel taskListModel = TaskListModel();
  bool _taskListProgress = false;
  Future<void> getProgressTask() async {
    _taskListProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.progressTaskList);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    _taskListProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            getProgressTask();
          },
          child: Column(
            children: [
              const ProfileSummary(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Visibility(
                    visible: _taskListProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                      itemCount: taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          color: Colors.purple,
                          task: taskListModel.taskList![index],
                          onDelete: () {
                            getProgressTask();
                          },
                          onStatusChange: (){
                            getProgressTask();
                          },
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
