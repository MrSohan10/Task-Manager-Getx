import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/complete_task_controller.dart';
import '../controller/main_bottom_nav_controller.dart';
import '../widget/profile_summary.dart';
import '../widget/task_item_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  CompleteTaskController _completeTaskController =
      Get.find<CompleteTaskController>();

  @override
  void initState() {
    super.initState();
    _completeTaskController.getCompletedTask();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        Get.find<MainBottomNavController>().backToHome();
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _completeTaskController.getCompletedTask();
            },
            child: Column(
              children: [
                const ProfileSummary(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(child:
                    GetBuilder<CompleteTaskController>(builder: (controller) {
                  return Visibility(
                    visible: controller.taskListProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                      itemCount: controller.taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          color: Colors.green,
                          task: controller.taskListModel.taskList![index],
                          onDelete: () {
                            controller.getCompletedTask();
                          },
                          statusChange: () {
                            controller.getCompletedTask();
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
      ),
    );
  }
}
