import 'package:flutter/material.dart';
import 'package:safecampus/controllers/auth_controller.dart';
import 'package:safecampus/widgets/custom_textbox.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key, this.email}) : super(key: key);
  final String? email;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/upside down.png'),
              fit: BoxFit.fill)),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Reset Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CustomTextBox(
                controller: emailController,
                labelText: "Email",
                hintText: "Enter email"),
            ElevatedButton(
                onPressed: () {
                  var future = auth.resetPassword(email: emailController.text);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                          future: future,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              var result = snapshot.data;

                              if (result == 'user-not-found') {
                                return AlertDialog(
                                  content: const Text(
                                      "Entered email is not present in our system"),
                                  title: const Text("Invalid Email-ID",
                                      style: TextStyle(color: Colors.black)),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Okay")),
                                  ],
                                );
                              }

                              return AlertDialog(
                                content: const Text(
                                    "An email has been sent to the respective email. Kindly check your inbox"),
                                title: const Text("Mail Sent",
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.justify),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Okay")),
                                ],
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        );
                      });
                },
                child: const Text("Send Reset Link")),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
