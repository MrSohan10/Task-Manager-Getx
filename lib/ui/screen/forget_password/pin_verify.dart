import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screen/forget_password/set_password.dart';
import 'package:task_manager/ui/screen/login_screen.dart';
import 'package:task_manager/ui/widget/body_background.dart';

import '../../../data/model/receive_mail_otp.dart';
import '../../../data/network_caller.dart';
import '../../../data/network_response.dart';
import '../../../data/utility.dart';
import '../../widget/snackbar_message.dart';

class PinVerification extends StatefulWidget {
  const PinVerification({super.key});

  @override
  State<PinVerification> createState() => _PinVerificationState();
}

class _PinVerificationState extends State<PinVerification> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;
  ReceiveMailAndOtp receiveOtp = ReceiveMailAndOtp();

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
                      "Pin Verification",
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
                    PinCodeTextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: "*",
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: Colors.green,
                        selectedColor: Colors.blue,
                        inactiveColor: Colors.red,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                      enableActiveFill: true,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        return true;
                      },
                      appContext: context,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter Value";
                        }
                        if (value!.length < 6) {
                          return "Enter 6 digit";
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
                        replacement: const Center(child: CircularProgressIndicator(),),
                        child: ElevatedButton(
                          onPressed: verifyPin,
                          child: const Text(
                            'verify',
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

  Future<void> verifyPin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _inProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller().getRequest(
        Urls.verifyPin(ReceiveMailAndOtp.mail, _pinController.text.trim()));
    _inProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      receiveOtp.receiveOtp(_pinController.text.trim());
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SetPassword()));
    } else {
      if (mounted) {
        showSnackbar(context, 'verify failed! please try again', true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pinController.dispose();
  }
}


