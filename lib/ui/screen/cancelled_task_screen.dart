import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/canceled_task_controller.dart';
import '../widget/profile_summary.dart';
import '../widget/task_item_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  CancelledTaskController _cancelledTaskController =
      Get.find<CancelledTaskController>();

  @override
  void initState() {
    super.initState();
    _cancelledTaskController.getCancelledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: GetBuilder<CancelledTaskController>(
                  builder: (controller) {
                    return Visibility(
              visible: controller.taskListProgress == false,
              replacement: const Center(
                    child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                    itemCount: controller.taskListModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        color: Colors.red,
                        task: controller.taskListModel.taskList![index],
                        onDelete: () {
                          controller.getCancelledTask();
                        },
                        statusChange: () {
                          controller.getCancelledTask();
                        },
                      );
                    },
              ),
            );
                  }
                )),
          ],
        ),
      ),
    );
  }
}
