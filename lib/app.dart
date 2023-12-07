import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/canceled_task_controller.dart';
import 'package:task_manager/ui/controller/complete_task_controller.dart';
import 'package:task_manager/ui/controller/create_new_task_controller.dart';
import 'package:task_manager/ui/controller/delete_task_controller.dart';
import 'package:task_manager/ui/controller/login_controller.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/progress_task_controller.dart';
import 'package:task_manager/ui/controller/sign_up_controller.dart';
import 'package:task_manager/ui/controller/task_count_controller.dart';
import 'package:task_manager/ui/controller/update_task_status_controller.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';

class TaskManager extends StatelessWidget {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  const TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigationKey,
      home: const SplashScreen(),
      initialBinding: ControllerBinder(),
      theme: ThemeData(
          primaryColor: Colors.green,
          primarySwatch: Colors.green,
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
          ))),
    );
  }
}

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
    Get.put(LoginController());
    Get.put(TaskCountController());
    Get.put(NewTaskController());
    Get.put(ProgressTaskController());
    Get.put(CompleteTaskController());
    Get.put(CancelledTaskController());
    Get.put(UpdateTaskStatusController());
    Get.put(DeleteTaskController());
    Get.put(CreateNewTaskController());

  }
}
