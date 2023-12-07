import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_count.dart';
import 'package:task_manager/data/model/task_count_model.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/network_caller.dart';
import 'package:task_manager/data/network_response.dart';
import 'package:task_manager/ui/screen/add_new_task.dart';

import '../../data/utility.dart';
import '../widget/profile_summary.dart';
import '../widget/summary_card.dart';
import '../widget/task_item_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  TaskListModel taskListModel = TaskListModel();
  TaskCountModel taskCountModel = TaskCountModel();
  bool _taskListProgress = false;
  bool _taskCountProgress = false;

  Future<void> getTaskCount() async {
    _taskCountProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskCount);
    if (response.isSuccess) {
      taskCountModel = TaskCountModel.fromJson(response.jsonResponse);
    }
    _taskCountProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTaskList() async {
    _taskListProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTaskList);
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
    getTaskCount();
    getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewTaskScreen(
                        onSave: () {
                          getTaskCount();
                          getNewTaskList();
                        },
                      )));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            getTaskCount();
            getNewTaskList();
          },
          child: Column(
            children: [
              const ProfileSummary(),
              Visibility(
                visible: _taskCountProgress == false &&
                    (taskCountModel.taskCountList?.isNotEmpty ?? false),
                replacement: const LinearProgressIndicator(),
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskCountModel.taskCountList?.length ?? 0,
                    itemBuilder: (context, index) {
                      TaskCount taskCount =
                          taskCountModel.taskCountList![index];
                      return FittedBox(
                        child: SummaryCard(
                          count: taskCount.sum.toString(),
                          title: taskCount.sId ?? '',
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                      color: Colors.blue,
                      task: taskListModel.taskList![index],
                      onDelete: () {
                        getTaskCount();
                        getNewTaskList();
                      },
                      onStatusChange: () {
                        getTaskCount();
                        getNewTaskList();
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
