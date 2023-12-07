import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_model.dart';

import '../../data/network_caller.dart';
import '../../data/network_response.dart';
import '../../data/utility.dart';
import '../widget/profile_summary.dart';
import '../widget/task_item_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  TaskListModel taskListModel = TaskListModel();
  bool _taskListProgress = false;
  Future<void> getCompletedTask() async {
    _taskListProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.completeTaskList);
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
    getCompletedTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            getCompletedTask();
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
                          color: Colors.green,
                          task: taskListModel.taskList![index],
                          onDelete: () {
                            getCompletedTask();
                          },
                          onStatusChange: (){
                            getCompletedTask();
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
