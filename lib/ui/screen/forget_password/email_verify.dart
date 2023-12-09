import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/network_caller.dart';
import 'package:task_manager/data/network_response.dart';
import 'package:task_manager/ui/controller/email_verify_controller.dart';
import 'package:task_manager/ui/screen/forget_password/pin_verify.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';

import '../../../data/model/receive_mail_otp.dart';
import '../../../data/utility.dart';
import '../../widget/snackbar_message.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      "A 6 digit verification pin will send to your email address",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Enter Email",
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Value";
                        } else if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)) {
                          return null;
                        }
                        ;
                        return "invalid E-mail";
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<EmailVerifyController>(
                        builder: (controller) {
                          return Visibility(
                            visible: controller.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: verifyEmail,
                              child: const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        }
                      ),
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

  Future<void> verifyEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await Get.find<EmailVerifyController>()
        .verifyEmail(_emailController.text.trim());

    if (response) {
      Get.to(const PinVerification());
    } else {
      if (mounted) {
        showSnackbar(context, Get.find<EmailVerifyController>().failedMessage, true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }
}
