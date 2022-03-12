import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safecampus/models/assessment.dart';
import 'package:safecampus/models/profile.dart';
import 'package:safecampus/models/user.dart';
import 'package:safecampus/models/response.dart' as response;

import '../firebase.dart';
import 'auth_controller.dart';
import 'dashboard_controller.dart';

final users = firestore.collection("Users");

class UserController extends GetxController {
  UserModel? user;
  static UserController instance = Get.find();
  int pendingAssesments = 0;
  List<Assessment> allAssesments = [];

  UserController(this.user);

  get name => user?.bioData.name;
  get id => user?.bioData.id;
  get superId => user?.bioData.superId;
  get groupid => user?.device?.groupId;
  get deviceid => user?.device?.groupId;
  get houseAddress => user?.bioData.houseAddress;
  get residenceAddress => user?.bioData.residenceAddress;
  get countryCode => user?.bioData.countryCode;
  get phoneNumber => user?.bioData.phoneNumber;

  List<String> get completedIds => user!.assessments != null ? user!.assessments!.map((e) => e.id).toList() : [];

  List<Assessment> get pendingAssesmentList {
    List<Assessment> assesments = [];

    if (completedIds.isEmpty) {
      return allAssesments;
    }
    assesments = allAssesments.where((element) => !completedIds.contains(element.id)).toList();
    return assesments;
  }

  UserFormController get formController => UserFormController.fromProfile(user!);

  loadProfile() {
    users.doc(auth.uid).get().then((value) {
      if (value.exists) {
        user = UserModel.fromJson(value.data()!);

        listenProfile();
        listenContacts();
        listenAssesments();
        listenMyAssesments();
      }
    });
    update();
  }

  listenProfile() {
    users.doc(auth.uid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        user = UserModel.fromJson(snapshot.data()!);
        if (user!.quarantine != null) {
          if (DateTime.now().isAfter(user!.quarantine!.endDate)) {
            users.doc(user!.uid).update({"quarantine": null});
          }
        }
      } else {
        user = null;
      }
      update();
    });
  }

  void createUser(UserModel user) {
    users.doc(user.uid).set(user.toJson()).then((value) => null).catchError((error) => null);
  }

  Future updateUser(UserFormController controller) async {
    var profile = controller.profile;
    if (controller.localFile != null) {
      profile.imageUrl = await storage.ref("profiles").child(auth.uid!).putFile(controller.localFile!).then((snapshot) async {
        return await snapshot.ref.getDownloadURL();
      });
    }
    return users.doc(auth.uid).update({"bioData": profile.toJson(), "search": profile.searchString}).then((value) {
      print(user!.device?.toJson());

      return response.Response.success("User Profile updated successfully");
    }).catchError((error) => response.Response.error(error.toString()));
  }

  Future<response.Response> addCovidInfo(CovidInfo covidInfo) async {
    user!.covidHistory = user!.covidHistory ?? [];
    user!.covidHistory!.add(covidInfo);
    user!.covidHistory!.sort((a, b) => a.date!.compareTo(b.date!));
    return await users.doc(user!.uid).update({
      "covidHistory": user!.covidHistory!.map((e) => e.toJson()).toList(),
      "covidInfo": user!.covidHistory?.last.toJson(),
    }).then((value) {
      update();
      return response.Response.success("Covid Information added");
    }).onError((error, stackTrace) => response.Response.error(error.toString()));
  }

  updateToken() {
    firebaseMessaging.getToken().then((value) => users.doc(auth.uid!).update({"fcm": value}).then((value) => null));
  }

  listenContacts() {
    databaseRef.child("contacts").child(auth.uid!).onValue.listen((event) {
      loadContacts();
    });
  }

  listenAssesments() {
    Assessment.getAssesments().listen((snapshots) {
      allAssesments = snapshots.docs.map((e) => Assessment.fromJson(e.data())).toList();

      update();
    });
  }

  listenMyAssesments() {
    users.doc(auth.uid).collection("Assessments").snapshots().listen((snapshots) {
      user!.assessments = snapshots.docs.map((e) => Assessment.fromJson(e.data())).toList();
      update();
    });
  }

  loadContacts() async {
    List<ContactHistory>? returns = [];
    Map? contacts = await databaseRef.child("contacts").child(auth.uid!).get().then((result) {
          return result.value;
        }) as Map? ??
        {};

    for (var json in contacts.values) {
      returns.add(ContactHistory(
        contact: json["contact"],
        fcm: json["fcm"] ?? '',
        totalTimeinContact: json["totalTimeinContact"],
        groupId: json["groupId"],
        deviceId: json["deviceId"],
        gateWay: json["gateWay"],
        lastContact: DateTime.fromMillisecondsSinceEpoch(json["lastContact"] * 1000),
      ));
    }

    user?.contactHistory = returns;
    if (kDebugMode) {
      print(user!.contactHistory!.length);
      print(returns.map((e) => e.toJson()));
    }
    update();
    return returns;
  }

  Future<void> loadAssesments() async {
    user!.assessments =
        await users.doc(auth.uid).collection("Assessments").get().then((value) => value.docs.map((e) => Assessment.fromJson(e.data())).toList());
  }
}

UserController userController = UserController.instance;

class UserFormController {
  final TextEditingController name;

  final TextEditingController id;
  final TextEditingController superId;
  final TextEditingController groupid;
  final TextEditingController deviceid;
  final TextEditingController permanentAddress;
  final TextEditingController currentAddress;
  final TextEditingController countryCode;
  final TextEditingController phoneNumber;

  UserType userType;
  String? department;
  String? uid;
  String? imageUrl;
  File? localFile;

  UserFormController({
    required this.name,
    required this.id,
    required this.superId,
    required this.groupid,
    required this.deviceid,
    this.userType = UserType.localStudent,
    this.department,
    this.uid,
    this.imageUrl,
    required this.permanentAddress,
    required this.currentAddress,
    required this.countryCode,
    required this.phoneNumber,
  });

  factory UserFormController.fromProfile(UserModel user) => UserFormController(
        name: TextEditingController(text: user.bioData.name),
        id: TextEditingController(text: user.bioData.id),
        superId: TextEditingController(text: user.bioData.superId),
        groupid: user.device == null ? TextEditingController() : TextEditingController(text: user.device!.groupId.toString()),
        deviceid: user.device == null ? TextEditingController() : TextEditingController(text: user.device!.deviceId.toString()),
        permanentAddress: TextEditingController(text: user.bioData.houseAddress),
        currentAddress: TextEditingController(text: user.bioData.residenceAddress),
        countryCode: TextEditingController(text: user.bioData.countryCode),
        phoneNumber: TextEditingController(text: user.bioData.phoneNumber),
        department: user.bioData.department,
        userType: user.bioData.userType,
        uid: user.uid,
        imageUrl: user.bioData.imageUrl,
      );

  factory UserFormController.plain() => UserFormController(
      name: TextEditingController(),
      department: dashboard.departments.isEmpty ? null : dashboard.departments.first.id,
      deviceid: TextEditingController(),
      groupid: TextEditingController(),
      id: TextEditingController(),
      superId: TextEditingController(),
      permanentAddress: TextEditingController(),
      countryCode: TextEditingController(text: '+'),
      phoneNumber: TextEditingController(),
      currentAddress: TextEditingController(),
      imageUrl: null,
      userType: UserType.localStudent);

  Profile get profile => Profile(
        id: id.text,
        superId: superId.text,
        email: auth.currentUser!.email!,
        name: name.text,
        phoneNumber: phoneNumber.text,
        houseAddress: permanentAddress.text,
        residenceAddress: currentAddress.text,
        countryCode: countryCode.text,
        department: department!,
        userType: userType,
        imageUrl: imageUrl,
      );
}
