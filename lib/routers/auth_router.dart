import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safecampus/controllers/auth_controller.dart';
import 'package:safecampus/controllers/profile_controller.dart';

import 'package:safecampus/screens/auth/login.dart';
import 'package:safecampus/screens/auth/verify_email.dart';
import 'package:safecampus/screens/home.dart';
import 'package:safecampus/screens/profile/profile_form.dart';

class AuthRouter extends StatelessWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          User user = snapshot.data!;

          if (user.emailVerified) {
            return GetBuilder<UserController>(
                init: userController,
                builder: (context) {
                  if (userController.user == null) {
                    return const ProfileForm();
                    // return Container(color: Colors.amber);
                  } else {
                    return const Home();
                    // return Container(color: Colors.green);
                  }
                });
          } else {
            return const VerifyEmail();
          }
        } else {
          return const Login();
        }
      },
    );
  }
}
