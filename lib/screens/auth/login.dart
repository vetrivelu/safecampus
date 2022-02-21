import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:safecampus/constants/themeconstants.dart';
import 'package:safecampus/controllers/auth_controller.dart';

import 'package:safecampus/screens/auth/signup.dart';
import 'package:safecampus/widgets/custom_textform_field.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  ColorFilter? filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      // backgroundColor: Colors.redAccent.withOpacity(0.9),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            // colorFilter: filter,
            scale: 30,
            image: AssetImage('assets/images/background.png'),

            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          )),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Safe Campus",
                          style: getText(context).headline6!.copyWith(color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 30, 20),
                          child: Image.asset(
                            'assets/images/iukl_logo.png',
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              hintText: 'Enter your email',
                              labelText: 'Email',
                              controller: emailController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: passwordController,
                              hintText: 'Enter your password',
                              labelText: 'Password',
                              obscureText: obscureText,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: obscureText
                                    ? const Icon(
                                        Icons.visibility_off_outlined,
                                        color: Colors.black,
                                        size: 22,
                                      )
                                    : const Icon(
                                        Icons.visibility_outlined,
                                        color: Colors.black,
                                        size: 22,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.12,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(10),
                            shadowColor: MaterialStateProperty.all(Colors.redAccent),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                          ),
                          onPressed: () async {
                            String title = '', message = '';
                            if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                              title = "Empty Email or Password";
                              message = "Please fill-out both email and password";
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(title),
                                      content: Text(message),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Okay")),
                                      ],
                                    );
                                  });
                            } else if (!emailController.text.isEmail) {
                              title = "Invalid Email";
                              message = "Please enter a valid email";
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(title),
                                      content: Text(message),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Okay")),
                                      ],
                                    );
                                  });
                            } else {
                              await auth.signInWithEmailAndPassword(emailController.text, passwordController.text).then((value) {
                                Navigator.of(context).popAndPushNamed('/');
                              }).catchError((error) {
                                title = error.code ?? "Error";
                                message = error.message ?? "Unknown Error";
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(title),
                                        content: Text(message),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Okay")),
                                        ],
                                      );
                                    });
                              });
                            }
                          },
                          child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return ForgotPassword(
                                email: emailController.text,
                              );
                            });
                      },
                      child: const Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    // const Text("OR"),
                    // TextButton(
                    //   onPressed: () {
                    //     // ignore: avoid_print
                    //     // print("Pressed");
                    //   },
                    //   child: const Text(
                    //     'Log in with OTP ',
                    //     style: TextStyle(
                    //       fontFamily: 'Lexend Deca',
                    //       color: Colors.blue,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.normal,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member ?',
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return SignUpWidget(
                                      email: emailController.text,
                                    );
                                  });
                            },
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
