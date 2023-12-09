import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/controller/update_profile_controller.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/profile_summary.dart';
import '../widget/snackbar_message.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UpdateProfileController _updateProfileController =
      Get.find<UpdateProfileController>();
 final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _emailController.text = _authController.user?.email ?? "";
    _firstNameController.text = _authController.user?.firstName ?? "";
    _lastNameController.text = _authController.user?.lastName ?? "";
    _mobileController.text = _authController.user?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(
              enableOnTap: false,
            ),
            Expanded(
              child: BodyBackground(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 32,
                            ),
                            Text(
                              "Update Profile",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            photoPickerField(),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Email",
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
                              height: 8,
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                hintText: "First Name",
                              ),
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return "Enter Value";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                hintText: "Last Name",
                              ),
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return "Enter Value";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Mobile",
                              ),
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return "Enter Value";
                                } else if (RegExp(
                                        r"^(?:(?:\+|00)88|01)?\d{11}$")
                                    .hasMatch(value!)) {
                                  return null;
                                }
                                return "Enter valid 11 digit number";
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                hintText: "Password (optional)",
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: GetBuilder<UpdateProfileController>(
                                  builder: (controller) {
                                return Visibility(
                                  visible: controller.updateInProgress == false,
                                  replacement: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: updateProfile,
                                    child: const Text(
                                      "Update",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await _updateProfileController.updateProfile(
        _emailController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _mobileController.text.trim(),
        _passwordController.text,
        );

    if (response) {
      if (mounted) {
        showSnackbar(context, _updateProfileController.message);
      }
      Get.back();
    } else {
      showSnackbar(context, _updateProfileController.failedMessage, true);
    }
  }

  Container photoPickerField() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  showPhotoPickerBottomModel();
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: GetBuilder<UpdateProfileController>(
                    builder: (updateProfileController) {
                      return Visibility(
                        visible: updateProfileController.photo == null,
                        replacement: Text(updateProfileController.photo?.name ?? ""),
                        child: const Text('Select a photo'),
                      );
                    }
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void showPhotoPickerBottomModel() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50);
                              if (image != null) {
                                _updateProfileController.receiveImage(image);
                              }
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.image,
                              size: 36,
                              color: Colors.green,
                            )),
                        const Text("  Gallery", style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final XFile? image = await ImagePicker()
                                  .pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 50);
                              if (image != null) {
                                _updateProfileController.receiveImage(image);
                              }
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.camera_alt_rounded,
                              size: 36,
                              color: Colors.green,
                            )),
                        const Text(
                          "  Camera",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
  }
}
