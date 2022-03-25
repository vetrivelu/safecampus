import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safecampus/controllers/auth_controller.dart';

import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/models/user.dart';

import 'package:safecampus/screens/auth/login.dart';
import 'package:safecampus/screens/auth/verify_email.dart';
import 'package:safecampus/screens/home.dart';
import 'package:safecampus/screens/profile/profile_form.dart';

class AuthRouter extends StatefulWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  State<AuthRouter> createState() => _AuthRouterState();
}

class _AuthRouterState extends State<AuthRouter> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          User user = snapshot.data!;

          if (true) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: users.doc(auth.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData) {
                    if (snapshot.data != null) {
                      if (snapshot.data!.exists) {
                        userController.user =
                            UserModel.fromJson(snapshot.data!.data()!);
                        if (userController.user != null) {
                          return Home();
                        } else {
                          return const ProfileForm();
                        }
                      }
                    }
                    return const ProfileForm();
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
