import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> announcements = firestore.collection('Announcements');

class Announcement {
  Announcement({
    this.attachementUrl,
    required this.title,
    required this.description,
    this.content,
    // required this.documentId,
    this.createdDate,
    required this.urls,
  });

  String? attachementUrl;
  String title;
  String description;
  String? content;
  // late String documentId;
  DateTime? createdDate;
  List<dynamic> urls;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        attachementUrl: json["attachementUrl"],
        title: json["title"],
        description: json["description"],
        content: json["content"],
        // documentId: json["documentID"],
        createdDate: json["createdDate"].toDate(),
        urls: json["urls"] ?? [],
      );
  static Future<QuerySnapshot<Map<String, dynamic>>> getAnnouncement(DocumentSnapshot? announcmentSnapshot) {
    if (announcmentSnapshot != null) {
      return announcements.orderBy("createdDate", descending: true).startAfterDocument(announcmentSnapshot).limit(15).get();
    } else {
      return announcements.limit(15).orderBy("createdDate", descending: true).get();
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllAnnouncement() {
    return announcements.orderBy("createdDate", descending: true).get();
  }

  Map<String, dynamic> toJson() => {
        "attachementUrl": attachementUrl,
        "title": title,
        "description": description,
        "content": content,
        // "documentID": documentId,
        "createdDate": createdDate
      };
}
