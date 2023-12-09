import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/ui/screen/update_profile.dart';

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({
    super.key,
    this.enableOnTap = true,
  });

  final bool enableOnTap;

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  // String? imageFormat = Get.find<AuthController>().user?.photo ?? "";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      // if (imageFormat!.startsWith('data:image')) {
      //   imageFormat =
      //       imageFormat!.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), " ");
      // }
      Uint8List imageBytes = const Base64Decoder().convert(controller.user?.photo??'');
      return ListTile(
          onTap: () {
            if (widget.enableOnTap) {
              Get.to(const UpdateProfile());
            }
          },
          tileColor: Colors.green,
          leading: CircleAvatar(
              child: imageBytes.isEmpty
                  ? const Icon(Icons.person_2_outlined)
                  : CircleAvatar(
                      backgroundImage: Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      ).image,
                    )),
          title: Text(
            fullName,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          subtitle: Text(
            Get.find<AuthController>().user?.email ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            onPressed: showLogOutDialog,
            icon: Icon(Icons.logout_outlined),
          ));
    });
  }

  String get fullName {
    return '${Get.find<AuthController>().user?.firstName ?? ''} ${Get.find<AuthController>().user?.lastName ?? ''}';
  }

  void showLogOutDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("LogOut"),
            content: Text("Do you want to Logout?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await AuthController.clearAuthData();
                    Get.offAll(const LoginScreen());
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
