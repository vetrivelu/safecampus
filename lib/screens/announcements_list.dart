import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/announcements.dart';
import 'announcementpage.dart';

class AnnouncementList extends StatelessWidget {
  const AnnouncementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF4C43),
        title: const Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Announcement.getAllAnnouncement(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data as QuerySnapshot<Map<String, dynamic>>;
            var items = data.docs.map((e) => Announcement.fromJson(e.data())).toList();
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(items[index].title),
                    subtitle: Text(
                      items[index].createdDate!.toString().substring(0, 10),
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          items[index].description,
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
                      items[index].urls.isEmpty
                          ? const Text("No attachmnents for this announcement")
                          : SizedBox(
                              height: MediaQuery.of(context).size.width * 0.25,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: items[index]
                                      .urls
                                      .map((e) => DownloadPreview(
                                            url: e,
                                            onPressed: () {
                                              Get.to(() => MultiImageViewer(urls: items[index].urls.map((e) => e.toString()).toList()));
                                            },
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                      const Divider(),
                    ],
                    // trailing: items[index].urls.isNotEmpty ? SizedBox(width: 30, child: Image.network(items[index].urls.first)) : Container(),
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error occured"),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DownloadPreview extends StatelessWidget {
  const DownloadPreview({
    Key? key,
    required this.url,
    required this.onPressed,
  }) : super(key: key);

  final String url;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                url,
                fit: BoxFit.contain,
                color: Colors.black38,
                colorBlendMode: BlendMode.multiply,
              )),
        ),
      ),
    );
  }
}
