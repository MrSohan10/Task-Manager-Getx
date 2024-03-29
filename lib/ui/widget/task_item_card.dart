import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/model/task.dart';
import '../controller/delete_task_controller.dart';
import '../controller/update_task_status_controller.dart';

enum TaskStatus { New, Progress, Completed, Cancelled }

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.color,
    required this.onDelete,
    required this.statusChange,
  });

  final VoidCallback onDelete;
  final VoidCallback statusChange;
  final Color color;
  final Task task;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(left: 10, right: 10, top: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(widget.task.description ?? ''),
            Text("Date: ${widget.task.createdDate}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  side: BorderSide.none,
                  label: Text(
                    widget.task.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: widget.color,
                ),
                Wrap(
                  children: [
                    IconButton(
                        onPressed: showUpdateStatusModel,
                        icon: Icon(
                          Icons.edit_note,
                          size: 30,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: showDeleteDialog,
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                        )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> showUpdateStatusModel() async {
    List<ListTile> items = TaskStatus.values
        .map((e) => ListTile(
              title: Text('${e.name}'),
              onTap: () {
                Get.find<UpdateTaskStatusController>()
                    .updateTaskStatus(e.name, widget.statusChange, widget.task);
                Get.back();
              },
            ))
        .toList();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update Status"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: items,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  void showDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Task"),
            content: Text("Do you want to delete task?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.find<DeleteTaskController>()
                        .deleteTask(widget.task, widget.onDelete);
                    Get.back();
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }
}
