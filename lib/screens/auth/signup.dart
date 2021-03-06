import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:safecampus/constants/themeconstants.dart';
import 'package:safecampus/controllers/auth_controller.dart';
import 'package:safecampus/widgets/custom_textbox.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key, this.email}) : super(key: key);
  final String? email;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  void initState() {
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
    super.initState();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/upside down.png'),
        fit: BoxFit.fitHeight,
        alignment: Alignment.bottomCenter,
      )),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 16),
                  child: Text(
                    "Sign up",
                    style: getText(context).headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextBox(
                      controller: emailController,
                      labelText: "Email",
                      hintText: "Enter email"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextBox(
                      maxLines: 1,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: obscurePassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      obscureText: obscurePassword,
                      controller: passwordController,
                      labelText: "Password",
                      hintText: "Enter password"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextBox(
                      maxLines: 1,
                      obscureText: obscurePassword,
                      controller: confirmPasswordController,
                      labelText: "Confirm Password",
                      hintText: "Re-Enter password"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String title = '', message = '';
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        title = "Empty Email or Password";
                        message = "Please fill-out both email and password";
                      } else if (!emailController
                          .text.removeAllWhitespace.isEmail) {
                        title = "Invalid Email";
                        message = "Please enter a valid email";
                      } else {
                        print("object");
                        if (passwordController.text.toString() ==
                            confirmPasswordController.text.toString()) {
                          await auth
                              .createUserWithEmailAndPassword(
                                  emailController.text.removeAllWhitespace,
                                  passwordController.text)
                              .then((user) {
                            title = "Success";
                            message = "Please log in to continue";
                            if (user != null) {
                              user.sendEmailVerification();
                            }
                            Navigator.of(context).popAndPushNamed('/sign-in');
                          }).catchError((error) {
                            title =
                                (error.code ?? "Error").toString().capitalize!;
                            message = error.message ?? "Unknown Error";
                          });
                        } else {
                          title = "Password doesn't match";
                          // message = "Please enter a valid email";
                        }
                      }

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.red[100],
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icon/iuicon2.png",
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    title,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              content: Text(
                                message,
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Okay")),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text("Submit")),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
