import 'package:flutter/material.dart';
import 'package:safecampus/models/response.dart';

showFutureDialog(
    {required BuildContext context, required Future<dynamic> future, required void Function() onSuccess, required void Function() onFailure}) {
  print("I am in future dialog");
  showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                var response = snapshot.data as Response;
                return AlertDialog(
                  title: Text(
                    response.code,
                    style: const TextStyle(color: Colors.black),
                  ),
                  content: Text(response.message),
                  actions: [ElevatedButton(onPressed: response.code == "error" ? onFailure : onSuccess, child: const Text("Okay"))],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}
