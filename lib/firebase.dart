import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

final databaseRef = FirebaseDatabase.instance.ref();
// .refFromURL("https://kkm-beacon.asia-southeast1.firebasedatabase.app/");
final FirebaseFunctions functions = FirebaseFunctions.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

uploadFile(File file, String name) {
  return storage.ref("complaints").child(name).putFile(file).then((snapshot) {
    return snapshot.ref.getDownloadURL();
  });
}

Future<List<String>> uploadFiles(List<File> files) async {
  List<String> url = [];
  for (var file in files) {
    var res = await uploadFile(file, DateTime.now().microsecondsSinceEpoch.toString());
    url.add(res);
  }
  return url;
}
