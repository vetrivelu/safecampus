import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safecampus/models/complaint.dart';
import 'package:safecampus/screens/announcementpage.dart';
import 'package:flutter/services.dart';
import '../announcements_list.dart';

class MyComplaints extends StatelessWidget {
  const MyComplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: Complaint.myCompaints(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            List<Complaint> complaints = snapshot.data!.docs.map((e) => Complaint.fromJson(e.data())).toList();
            return ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ExpansionTile(
                      leading: Icon(
                        Icons.circle,
                        color: complaints[index].status ? Colors.green : Colors.yellow,
                      ),
                      title: Text(complaints[index].title),
                      subtitle: Text(
                        complaints[index].raisedDate.toString().substring(0, 10),
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      children: [
                        ListTile(
                          title: Text("Complaint ID : ${complaints[index].name}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: complaints[index].name)).then(
                                    (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Complaint ID Copied"))));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            complaints[index].description,
                          ),
                        ),
                        const Divider(),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Attachments", textAlign: TextAlign.left),
                          ),
                        ),
                        (complaints[index].files ?? []).isEmpty
                            ? const Text("No attachmnents for this Complaint")
                            : SizedBox(
                                height: MediaQuery.of(context).size.width * 0.25,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: (complaints[index].files ?? [])
                                        .map((e) => DownloadPreview(
                                              url: e,
                                              onPressed: () {
                                                Get.to(
                                                    () => MultiImageViewer(urls: (complaints[index].files ?? []).map((e) => e.toString()).toList()));
                                              },
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                        const Divider(),
                      ],
                      // trailing: complaints[index].urls.isNotEmpty ? SizedBox(width: 30, child: Image.network(items[index].urls.first)) : Container(),
                    ),
                  );
                });
          }
          if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error.toString());
              log(snapshot.error.toString());
            }
            return const Text("Error Occured");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
