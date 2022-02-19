import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safecampus/controllers/auth_controller.dart';


class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void dispose() {
    _timer != null ? _timer!.cancel() : () {};
    super.dispose();
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      auth.currentUser!.reload();
      _timer = timer;
      auth.currentUser!.getIdTokenResult().then((value) => print(value.claims));
      if (auth.currentUser!.emailVerified) {
        Navigator.of(context).popAndPushNamed('/');
        timer.cancel();
      }
    });
    super.initState();
  }

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Email Not Verfied",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  "Your email has not been Verified. An email verification link has been sent to your email, Kindly click on the link to verify."),
            ),
            const Text("Didn't receive an email ? "),
            const Text("or "),
            const Text("Link expired ?"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {
                    auth.currentUser!.sendEmailVerification().then((value) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: const Text("A mail has been sent"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OKay"))
                                ]);
                          });
                    });
                  },
                  child: const Text("Send Verification email")),
            ),
            ElevatedButton(
              onPressed: () {
                auth.signOut();
              },
              child: const Text("Logout"),
            ),
            ElevatedButton(
              onPressed: () {
                auth.currentUser!.reload();
                Navigator.of(context).popAndPushNamed('/');
              },
              child: const Text("Check again"),
            ),
          ],
        ),
      ),
    );
  }
}
