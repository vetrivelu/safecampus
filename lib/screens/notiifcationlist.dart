import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safecampus/controllers/profile_controller.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  Widget getTile(Map<String, dynamic> json, void Function()? callback) {
    if (json["document"] != null) {
      return Card(
        child: ExpansionTile(
          title: Text(json["document"]["title"]),
          trailing: GestureDetector(onTap: callback, child: const Icon(Icons.delete)),
        ),
      );
    }
    return Card(
      child: ListTile(
        title: Text(json["document"]["title"]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification List"),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: users.doc(userController.user!.uid).collection('Notification').snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active || snapshot.hasData) {
              print(snapshot.data!.docs.length);
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return getTile(snapshot.data!.docs[index].data(), () {
                      snapshot.data?.docs[index].reference.delete();
                    });
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
