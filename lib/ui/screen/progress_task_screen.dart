import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/progress_task_controller.dart';
import '../widget/profile_summary.dart';
import '../widget/task_item_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTaskController _progressTaskController =
      Get.find<ProgressTaskController>();

  @override
  void initState() {
    super.initState();
    _progressTaskController.getProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _progressTaskController.getProgressTask();
          },
          child: Column(
            children: [
              const ProfileSummary(),
              const SizedBox(
                height: 10,
              ),
              Expanded(child:
                  GetBuilder<ProgressTaskController>(builder: (controller) {
                return Visibility(
                  visible: controller.taskListProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ListView.builder(
                    itemCount: controller.taskListModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        color: Colors.purple,
                        task: controller.taskListModel.taskList![index],
                        onDelete: () {
                          controller.getProgressTask();
                        },
                        statusChange: () {
                          controller.getProgressTask();
                        },
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
