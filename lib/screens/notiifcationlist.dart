import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safecampus/controllers/profile_controller.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  Widget getTile(Map<String, dynamic> json, void Function()? callback) {
    return Card(
      child: ListTile(
        leading: Text(DateFormat.MMMd().format(json["time"].toDate())),
        title: Text(json["title"]),
        subtitle: Text(json["description"]),
        trailing: IconButton(onPressed: callback, icon: const Icon(Icons.delete)),
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
