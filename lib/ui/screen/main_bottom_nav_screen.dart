import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/main_bottom_nav_controller.dart';
import 'package:task_manager/ui/screen/cancelled_task_screen.dart';
import 'package:task_manager/ui/screen/completed_task_screen.dart';
import 'package:task_manager/ui/screen/new_task_screen.dart';
import 'package:task_manager/ui/screen/progress_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  List<Widget> _screen = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainBottomNavController>(
      builder: (controller) {
        return Scaffold(
          body: _screen[controller.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex,
            onTap: (index) {
              controller.receiveIndex(index);
              setState(() {});
            },
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.task), label: "New Task"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.change_circle), label: "Progress"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline_rounded), label: "Completed"),
              BottomNavigationBarItem(icon: Icon(Icons.cancel), label: "Cancelled"),
            ],
          ),
        );
      }
    );
  }
}
