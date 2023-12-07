import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/model/task_count.dart';
import 'package:task_manager/data/model/task_count_model.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/network_caller.dart';
import 'package:task_manager/data/network_response.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/screen/add_new_task.dart';

import '../../data/utility.dart';
import '../controller/task_count_controller.dart';
import '../widget/profile_summary.dart';
import '../widget/summary_card.dart';
import '../widget/task_item_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  final TaskCountController _taskCountController =
      Get.find<TaskCountController>();

  @override
  void initState() {
    super.initState();
    _taskCountController.getTaskCount();
    _newTaskController.getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddNewTaskScreen());
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _taskCountController.getTaskCount();
            _newTaskController.getNewTaskList();
          },
          child: Column(
            children: [
              const ProfileSummary(),
              GetBuilder<TaskCountController>(builder: (taskCountController) {
                return Visibility(
                  visible: taskCountController.taskCountProgress == false &&
                      (taskCountController
                              .taskCountModel.taskCountList?.isNotEmpty ??
                          false),
                  replacement: const LinearProgressIndicator(),
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: taskCountController
                              .taskCountModel.taskCountList?.length ??
                          0,
                      itemBuilder: (context, index) {
                        TaskCount taskCount = taskCountController
                            .taskCountModel.taskCountList![index];
                        return FittedBox(
                          child: SummaryCard(
                            count: taskCount.sum.toString(),
                            title: taskCount.sId ?? '',
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Expanded(child:
                  GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                  visible: newTaskController.taskListProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ListView.builder(
                    itemCount:
                        newTaskController.taskListModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        color: Colors.blue,
                        task: newTaskController.taskListModel.taskList![index],
                      );
                    },
                  ),
                );
              })),
            ],
          ),
        ),
      ),
    );
  }
}
