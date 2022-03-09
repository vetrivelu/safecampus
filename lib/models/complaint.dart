import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:safecampus/controllers/auth_controller.dart';
import 'package:safecampus/models/response.dart';
import '../firebase.dart';

CollectionReference<Map<String, dynamic>> complaints = firestore.collection('Complaints');

class Complaint {
  Complaint({
    this.attachment,
    required this.title,
    required this.description,
    required this.raisedBy,
    required this.raisedDate,
    this.files,
  });

  String? attachment;
  String title;
  String description;
  String raisedBy;
  DateTime raisedDate;
  List<String>? files;

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
      attachment: json["attachment"],
      title: json["title"],
      description: json["description"],
      raisedBy: json["raisedBy"],
      raisedDate: json["raisedDate"].toDate(),
      files: json['files'] ?? []);

  Map<String, dynamic> toJson() => {
        "attachment": attachment,
        "title": title,
        "description": description,
        "raisedBy": raisedBy,
        "raisedDate": raisedDate,
        "files": files,
      };

  String get name => raisedDate.microsecondsSinceEpoch.toString();

  Future<void> add() async {
    return complaints.doc(name).set(toJson()).then((value) => null);
  }

  // static Future<Response> createComplaint({required String title, required String description, File? file}) async {
  //   String? url;
  //   var date = DateTime.now();
  //   try {
  //     if (file != null) {
  //       url = await uploadFile(file, date.microsecondsSinceEpoch.toString());
  //       if (kDebugMode) {
  //         print(url);
  //       }
  //     }
  //     return Complaint(attachment: url, title: title, description: description, raisedBy: auth.uid.toString(), raisedDate: date)
  //         .add()
  //         .then((value) => Response.success("Complaint successfully added"));
  //   } catch (error) {
  //     return Response.error(error.toString());
  //   }
  // }

  static Future<Response> createComplaint({required String title, required String description, required List<File> files}) async {
    List<String> url = [];
    var date = DateTime.now();
    try {
      if (files.isNotEmpty) {
        url = await uploadFiles(files);
        if (kDebugMode) {
          print(url);
        }
      }
      return Complaint(files: url, title: title, description: description, raisedBy: auth.uid.toString(), raisedDate: date)
          .add()
          .then((value) => Response.success("Complaint successfully added"));
    } catch (error) {
      return Response.error(error.toString());
    }
  }
}
