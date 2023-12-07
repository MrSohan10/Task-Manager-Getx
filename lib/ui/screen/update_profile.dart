import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/network_caller.dart';
import 'package:task_manager/data/network_response.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/widget/body_background.dart';
import 'package:task_manager/ui/widget/profile_summary.dart';

import '../../data/utility.dart';
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
  bool _updateInProgress = false;

  XFile? photo;

  @override
  void initState() {
    super.initState();
    _emailController.text = AuthController.user?.email ?? "";
    _firstNameController.text = AuthController.user?.firstName ?? "";
    _lastNameController.text = AuthController.user?.lastName ?? "";
    _mobileController.text = AuthController.user?.mobile ?? "";
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
                              child: Visibility(
                                visible: _updateInProgress == false,
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
                              ),
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
    _updateInProgress = true;
    if (mounted) {
      setState(() {});
    }
    String? photoInBase64;

    Map<String, dynamic> inputData = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };
    if (_passwordController.text.isNotEmpty) {
      inputData["password"] = _passwordController.text;
    }
    if (photo != null) {
      List<int> imageBytes = await photo!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData["photo"] = photoInBase64;
    }
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.updateProfile, body: inputData);
    _updateInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      AuthController.updateInformation(UserModel(
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          mobile: _mobileController.text.trim(),
          photo: photoInBase64 ?? AuthController.user?.photo));
      if (mounted) {
        showSnackbar(context, "Update profile Success!");
      }
      Navigator.pop(context);
    } else {
      showSnackbar(context, "Update failed! please try again.", true);
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
                  child: Visibility(
                    visible: photo == null,
                    replacement: Text(photo?.name ?? ""),
                    child: const Text('Select a photo'),
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
                                photo = image;
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.image,
                              size: 36,
                              color: Colors.green,
                            )),
                        Text("  Gallery", style: TextStyle(fontSize: 20))
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
                                photo = image;
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              size: 36,
                              color: Colors.green,
                            )),
                        Text(
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
