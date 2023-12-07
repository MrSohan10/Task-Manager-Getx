import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/login_controller.dart';
import 'package:task_manager/ui/screen/forget_password/email_verify.dart';
import 'package:task_manager/ui/screen/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/snackbar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController _loginController = Get.find<LoginController>();

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
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        hintText: "Enter Email",
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
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Password",
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter Value";
                        }
                        if (value!.length < 6) {
                          return "Enter password more then 6 digit";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<LoginController>(builder: (controller) {
                        return Visibility(
                          visible: controller.loginInProgress == false,
                          replacement:
                              const Center(child: CircularProgressIndicator()),
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(const EmailVerification());
                        },
                        child: const Text(
                          "Forget Password ?",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have account?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const SignUpScreen());
                          },
                          child: const Text(
                            "Sign up",
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

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await _loginController.login(
        _emailController.text.trim(), _passwordController.text);

    if (response) {
      Get.offAll(const MainBottomNavScreen());
    } else {
      if (mounted) {
        showSnackbar(context, _loginController.failedMessage, true);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
