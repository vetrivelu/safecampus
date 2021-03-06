import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:safecampus/controllers/auth_controller.dart';
import 'package:safecampus/controllers/dashboard_controller.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/models/profile.dart';
import 'package:safecampus/models/user.dart';
import 'package:safecampus/routers/auth_router.dart';
import 'package:safecampus/screens/profile/profile.dart';
import 'package:safecampus/screens/status/covid_history.dart';
import 'package:safecampus/widgets/custom_dropdown.dart';
import 'package:safecampus/widgets/custom_textbox.dart';
import 'package:safecampus/widgets/dialog.dart';

enum FormMode { registration, update }

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  void initState() {
    super.initState();
    if (userController.user != null) {
      controller = userController.formController;
      dashboard.getName(controller.department) == null ? controller.department = null : doNothing();
      mode = FormMode.update;
    } else {
      controller = UserFormController.plain();
      mode = FormMode.registration;
    }
  }

  late FormMode mode;

  ImageProvider getImageProvider() {
    if (controller.localFile != null) {
      return FileImage(controller.localFile!);
    } else if (controller.imageUrl != null) {
      return NetworkImage(controller.imageUrl!);
    }
    return const NetworkImage(url);
  }

  late UserFormController controller;

  List<DropdownMenuItem<UserType>>? get userTypeItems => UserType.values
      .map((e) => DropdownMenuItem(
          value: e,
          child: Text(
              e.toString().split('.').last.split(RegExp('(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])')).map((e) => e.capitalizeFirst!).join(" "))))
      .toList();

  List<DropdownMenuItem<String?>>? get departmentItems =>
      dashboard.departments.map((e) => DropdownMenuItem<String>(value: e.id, child: Text(e.name))).toList();

  Future<File?> _cropImage(String path) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    return croppedFile;
  }

  final _formKey = GlobalKey<FormState>();

  String? requiredValidator(String? val) {
    var text = val ?? '';
    if (text.isEmpty) {
      return "This is a required field";
    }
    return null;
  }

  String? icNumberValidator(String? val) {
    if (val!.length <= 14 && val.isNotEmpty) {
      var regex = RegExp(r'(([[0-9]{2})(0[0-9]|1[0-2])(0[0-9]|[12][0-9]|3[01]))-([0-9]{2})-([0-9]{4})');
      if (regex.hasMatch(val)) {
        return null;
      } else {
        return 'Please enter a valid IC Number';
      }
    } else {
      return "IC Number should contain 12 charachters";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            mode == FormMode.registration ? auth.signOut().then((value) => Get.offAll(() => const AuthRouter())) : Navigator.of(context).pop();
          },
        ),
        title: Text(userController.user != null ? "Edit Profile" : "Registration"),
        centerTitle: true,
      ),
      //=====================================Floating Action Button Here..............
      floatingActionButton: ElevatedButton(
        child: const Text("Submit"),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (mode == FormMode.update) {
              var future = userController.updateUser(controller);
              showFutureDialog(
                  context: context,
                  future: future,
                  onSuccess: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Get.offAndToNamed("/profile");
                  },
                  onFailure: () {
                    Navigator.of(context).pop();
                  });
            } else {
              userController.createUser(controller);
            }
          }
        },
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'avatar',
                        child: CircleAvatar(
                          backgroundImage: getImageProvider(),
                          radius: 45,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (xfile != null) {
                            controller.localFile = await _cropImage(xfile.path);
                          }
                          setState(() {});
                        },
                        child: const Text(
                          'Change Profile Picture',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  CustomTextBox(
                      validator: requiredValidator,
                      controller: TextEditingController(text: auth.currentUser!.email),
                      hintText: 'Your Email',
                      labelText: 'Email',
                      enabled: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CustomDropDown<UserType>(
                      selectedValue: controller.userType,
                      labelText: "User Type",
                      items: userTypeItems,
                      onChanged: (value) {
                        setState(() {
                          controller.userType = value ?? controller.userType;
                        });
                      },
                      hintText: '',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GetBuilder(
                        init: dashboard,
                        builder: (context) {
                          return CustomDropDown<String?>(
                              validator: (value) {
                                return value != null ? null : "Please select a department";
                              },
                              selectedValue: controller.department,
                              items: departmentItems,
                              labelText: "Department",
                              onChanged: (value) {
                                controller.department = value ?? controller.department;
                              });
                        }),
                  ),
                  // const Divider(),
                  CustomTextBox(
                      validator: requiredValidator,
                      controller: controller.name,
                      hintText: 'Enter your Name',
                      labelText: 'Name',
                      keyboardType: TextInputType.name),
                  CustomTextBox(
                      validator: requiredValidator,
                      controller: controller.id,
                      labelText: "ID",
                      hintText: "Enter ID",
                      keyboardType: TextInputType.text),
                  CustomTextBox(
                      validator: controller.userType == UserType.foreignStudent ? requiredValidator : icNumberValidator,
                      controller: controller.superId,
                      onChanged: (val) {
                        if (val.length == 7) {
                          var lastChar = val.substring(val.length - 1);
                          if (lastChar != '-') {
                            controller.superId.text = controller.superId.text.substring(0, 6) + '-' + lastChar;
                            controller.superId.selection = TextSelection.fromPosition(TextPosition(offset: controller.superId.text.length));
                          }
                        }
                        if (val.length == 10) {
                          var lastChar = val.substring(val.length - 1);
                          if (lastChar != '-') {
                            controller.superId.text = controller.superId.text.substring(0, 9) + '-' + lastChar;
                            controller.superId.selection = TextSelection.fromPosition(TextPosition(offset: controller.superId.text.length));
                          }
                        }
                      },
                      hintText: '991214-12-5338',
                      labelText: controller.userType == UserType.foreignStudent ? 'Passport Number' : 'IC Number',
                      keyboardType: TextInputType.number),
                  Table(
                    columnWidths: const {1: FlexColumnWidth(2)},
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: CustomTextBox(
                                validator: requiredValidator,
                                controller: controller.countryCode,
                                labelText: "Code",
                                hintText: "+60",
                                keyboardType: TextInputType.phone),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: CustomTextBox(
                                validator: requiredValidator,
                                controller: controller.phoneNumber,
                                labelText: "Phone",
                                hintText: "Enter Phone Number",
                                keyboardType: TextInputType.phone),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CustomTextBox(
                    validator: requiredValidator,
                    controller: controller.permanentAddress,
                    hintText: 'Enter Permanent Address',
                    labelText: "Permanent Address",
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                  CustomTextBox(
                    validator: requiredValidator,
                    controller: controller.currentAddress,
                    hintText: 'Enter Current Address',
                    labelText: "Current Address",
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 50)
                ],
              ),
            ),
          )),
    );
  }
}
