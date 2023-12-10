import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/set_password_controller.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';

import '../../../data/model/receive_mail_otp.dart';
import '../../../data/network_caller.dart';
import '../../../data/network_response.dart';
import '../../../data/utility.dart';
import '../../widget/snackbar_message.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Set Password",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      "Minimum length password 8 character with latter and number combination",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter Value";
                        }
                        if (value!.length < 8) {
                          return "Enter password more then 8 digit";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "confirm Password",
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter Value";
                        }
                        if (value!.length < 8) {
                          return "Enter password more then 8 digit";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<SetPasswordController>(
                          builder: (controller) {
                            return Visibility(
                              visible: controller.inProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: resetPassword,
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have account?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAll(const LoginScreen());
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text == _confirmPasswordController.text) {
      final response = await Get.find<SetPasswordController>()
          .resetPassword(_confirmPasswordController.text);

      if (response) {
        Get.offAll(const LoginScreen());
        if (mounted) {
          showSnackbar(
            context,
            Get
                .find<SetPasswordController>()
                .message,
          );
        }
      } else {
        if (mounted) {
          showSnackbar(
              context, Get
              .find<SetPasswordController>()
              .failedMessage, true);
        }
      }
    } else {
      if (mounted) {
        showSnackbar(context, 'Password Not match', true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }
}
