import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/sign_up_controller.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/snackbar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignupController _signupController = Get.find<SignupController>();

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
                      height: 50,
                    ),
                    Text("Join With Us",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
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
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Value";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Value";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Mobile",
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter Value";
                        } else if (RegExp(r"^(?:(?:\+|00)88|01)?\d{11}$")
                            .hasMatch(value!)) {
                          return null;
                        }
                        return "Enter valid 11 digit number";
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
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
                      child: GetBuilder<SignupController>(
                        builder: (controller) {
                          return Visibility(
                            visible: controller.signupInProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: signUP,
                              child: const Text(
                                "Sign up",
                                style: TextStyle(fontSize: 16),
                              ),
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
                           Get.offAll(const LoginScreen()) ;
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

  Future<void> signUP() async {
    if (_formKey.currentState!.validate()) {
      final response = await _signupController.signUP(
          _emailController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _mobileController.text.trim(),
          _passwordController.text);

      if (response) {
         Get.offAll(const LoginScreen());
        if (mounted) {
          showSnackbar(context, _signupController.message);
        }
      } else {
        if (mounted) {
          showSnackbar(
              context, _signupController.failedMessage, true);
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
