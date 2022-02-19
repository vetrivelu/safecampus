import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  get name => user?.bioData.name;
  get id => user?.bioData.id;
  get superId => user?.bioData.superId;
  get groupid => user?.device?.groupId;
  get deviceid => user?.device?.groupId;
  get houseAddress => user?.bioData.houseAddress;
  get residenceAddress => user?.bioData.residenceAddress;
  get countryCode => user?.bioData.countryCode;
  get phoneNumber => user?.bioData.phoneNumber;

  UserFormController get formController => UserFormController.fromProfile(user!);

  loadAssessments() {}

  listenProfile() {
    users.doc(auth.uid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        user = UserModel.fromJson(snapshot.data()!);
      } else {
        user = null;
      }
      update();
    });
  }

  void createUser(UserModel user) {
    users.doc(user.uid).set(user.toJson()).then((value) => null).catchError((error) => null);
  }

  updateUser(UserFormController controller) async {
    var profile = controller.profile;
    if (controller.localFile != null) {
      profile.imageUrl = await storage.ref("profiles").child(user!.uid).putFile(controller.localFile!).then((snapshot) async {
        return await snapshot.ref.getDownloadURL();
      });
    }

    return users
        .doc(auth.uid)
        .update({"bioData": profile.toJson()})
        .then((value) => response.Response.success("User Profile updated successfully"))
        .catchError((error) => response.Response.error(error.toString()));
  }

  Future<response.Response> addCovidInfo(CovidInfo covidInfo) async {
    var history = user?.covidHistory ?? [];
    history.add(covidInfo);
    return await users
        .doc(auth.uid)
        .update({"covidHistory": history.map((e) => e.toJson()).toList()})
        .then((value) => response.Response.success("Covid Information added"))
        .onError((error, stackTrace) => response.Response.error(error.toString()));
  }

  listenContacts() {
    databaseRef.child("contacts").child(auth.uid!).onValue.listen((event) {
      loadContacts();
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
        department: dashboard.departments.isEmpty ? null : dashboard.departments.first,
        deviceid: TextEditingController(),
        groupid: TextEditingController(),
        id: TextEditingController(),
        superId: TextEditingController(),
        permanentAddress: TextEditingController(),
        countryCode: TextEditingController(),
        phoneNumber: TextEditingController(),
        currentAddress: TextEditingController(),
      );

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
      userType: userType);
}
