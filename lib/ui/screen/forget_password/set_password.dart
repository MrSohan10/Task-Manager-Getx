import 'package:flutter/material.dart';
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
  bool _inProgress = false;

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
                      style: Theme.of(context).textTheme.titleLarge,
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
                      child: Visibility(
                        visible: _inProgress == false,
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
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
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
   if(_passwordController.text==_confirmPasswordController.text) {
      _inProgress = true;
      if (mounted) {
        setState(() {});
      }

      final NetworkResponse response =
          await NetworkCaller().postRequest(Urls.resetPass, body: {
        "email": ReceiveMailAndOtp.mail,
        "OTP": ReceiveMailAndOtp.otp,
        "password": _confirmPasswordController.text
      });
      _inProgress = false;
      if (mounted) {
        setState(() {});
      }

      if (response.isSuccess) {
        showSnackbar(
          context,
          'Password change successfully! please Login',
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      } else {
        if (mounted) {
          showSnackbar(context, 'Something is wrong! please try again', true);
        }
      }
    }else{
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
