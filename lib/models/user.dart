// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:safecampus/models/profile.dart';

import 'assessment.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.bioData,
    required this.uid,
    this.isStaff = false,
    this.device,
    this.quarantine,
    this.quarantineHistory,
    this.covidInfo,
    this.contactHistory,
    this.fcm,
    this.createdDate,
    this.assessments,
    this.covidHistory,
  });

  Profile bioData;
  String uid;
  bool isStaff;
  Device? device;
  Quarantine? quarantine;
  List<Quarantine>? quarantineHistory;
  CovidInfo? covidInfo;
  List<CovidInfo>? covidHistory;
  List<ContactHistory>? contactHistory;
  List<Assessment>? assessments;
  String? fcm;
  DateTime? createdDate;

  Map<String, dynamic> toRTDBJson() => {
        "bioData": bioData.name,
        "email": bioData.email,
        "uid": uid,
        "isGuest": false,
        "deviceID": device?.deviceId,
        "groupID": device?.groupId,
        "quarantine":
            quarantine != null ? quarantine!.location.place.toString() : null,
        "isCovid": latestCovid?.result ?? false,
        "fcm": fcm,
        "createdDate":
            createdDate != null ? createdDate!.toIso8601String() : null,
      };

  List<String> get searchString => makeSearchString(bioData.name);
  makeSearchString(String text) {
    List<String> returns = [];
    var length = text.length;
    for (int i = 0; i < length; i++) {
      returns.add(text.substring(0, i));
    }
    return returns;
  }

  CovidInfo? get latestCovid {
    List<CovidInfo> history = covidHistory ?? [];
    if (history.isEmpty) {
      return null;
    } else if (history.length == 1) {
      return history.first;
    }
    covidHistory!.sort((a, b) => a.date!.compareTo(b.date!));
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        bioData: Profile.fromJson(json["bioData"]),
        uid: json["uid"],
        isStaff: json["isStaff"],
        device: json["device"] != null ? Device.fromJson(json["device"]) : null,
        quarantine: json["quarantine"] != null
            ? Quarantine.fromJson(json["quarantine"])
            : null,
        covidInfo: json["covidInfo"] != null
            ? CovidInfo.fromJson(json["covidInfo"])
            : null,
        contactHistory: json["contactHistory"] != null
            ? List<ContactHistory>.from(
                json["contactHistory"].map((x) => ContactHistory.fromJson(x)))
            : [],
        covidHistory: json["covidHistory"] != null
            ? List<CovidInfo>.from(
                json["covidHistory"].map((x) => CovidInfo.fromJson(x)))
            : [],
        fcm: json["fcm"],
        createdDate: json["createdDate"]?.toDate(),
        assessments: [],
      );

  Map<String, dynamic> toJson() => {
        "bioData": bioData.toJson(),
        "uid": uid,
        "isStaff": isStaff,
        "device": device != null ? device!.toJson() : null,
        "quarantine": quarantine?.toJson(),
        "covidInfo": latestCovid?.toJson(),
        "contactHistory": contactHistory != null
            ? List<dynamic>.from(contactHistory!.map((x) => x.toJson()))
            : null,
        "covidHistory": covidHistory != null
            ? List<dynamic>.from(covidHistory!.map((x) => x.toJson()))
            : null,
        "fcm": fcm,
        "createdDate": createdDate,
        "search": bioData.searchString,
      };
}

class Device {
  Device({
    required this.groupId,
    required this.deviceId,
    this.dmac,
  });

  int groupId;
  int deviceId;
  String? dmac;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        groupId: json["groupID"],
        deviceId: json["deviceID"],
        dmac: json["dmac"],
      );

  Map<String, dynamic> toJson() => {
        "groupID": groupId,
        "deviceID": deviceId,
        "dmac": dmac,
      };
}

class Quarantine {
  Quarantine({
    required this.startDate,
    required this.endDate,
    required this.location,
  });

  DateTime startDate;
  DateTime endDate;
  Location location;

  factory Quarantine.fromJson(Map<String, dynamic> json) => Quarantine(
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "location": location.toJson(),
      };
}

class Location {
  Location({
    required this.place,
    this.floor,
    this.block,
    this.inCampus = true,
    this.quarantineAddress,
    this.roomNumbmer,
    this.outCampus,
  });

  String? place;
  int? floor;
  String? block;
  String? roomNumbmer;
  bool inCampus;
  String? quarantineAddress;
  String? outCampus;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        place: json["inCampus"] ? json["place"] : null, //building name
        floor: json["inCampus"] ? json["floor"] : null, //buil
        block: json["inCampus"] ? json["block"] : null, //buil
        roomNumbmer: json["inCampus"] ? json["roomNumbmer"] : null, //buil
        inCampus: json["inCampus"],
        outCampus: json["inCampus"] ? null : json["outCampus"],
        quarantineAddress: json["quarantineAddress"],
      );

  Map<String, dynamic> toJson() => {
        "place": place,
        "floor": floor,
        "block": block,
        "inCampus": inCampus,
        "quarantineAddress": quarantineAddress,
        "roomNumbmer": roomNumbmer,
        "outCampus": outCampus,
      };
}

class CovidInfo {
  CovidInfo({
    this.result = false,
    this.method,
    this.type,
    this.date,
    this.vaccinated = false,
    this.vaccinatedOn,
  });

  bool result;
  String? method;
  String? type;
  DateTime? date;
  bool vaccinated;
  DateTime? vaccinatedOn;

  factory CovidInfo.fromJson(Map<String, dynamic> json) => CovidInfo(
      result: json["result"] ?? false,
      method: json["method"],
      type: json["type"],
      date: json["date"]?.toDate(),
      vaccinated: json["vaccinated"],
      vaccinatedOn: json["vaccinatedOn"]?.toDate());

  Map<String, dynamic> toJson() => {
        "result": result,
        "method": method,
        "type": type,
        "date": date,
        "vaccinated": vaccinated,
        "vaccinatedOn": vaccinatedOn,
      };
}

class ContactHistory {
  ContactHistory({
    required this.contact,
    required this.fcm,
    required this.totalTimeinContact,
    this.deviceID,
    this.groupId,
    this.gateWay,
    this.lastContact,
    this.covidStatus = false,
    deviceId,
  });

  String contact;
  bool covidStatus;
  int? groupId;
  int? deviceID;
  String fcm;
  int totalTimeinContact;
  String? gateWay;
  DateTime? lastContact;

  factory ContactHistory.fromJson(Map<String, dynamic> json) => ContactHistory(
        contact: json["contact"],
        fcm: json["fcm"] ?? "",
        totalTimeinContact: json["totalTimeinContact"],
        groupId: json["groupId"],
        deviceID: json["deviceId"],
        gateWay: json["gateWay"],
        lastContact: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "contact": contact,
        "fcm": fcm,
        "totalTimeinContact": totalTimeinContact,
        "deviceId": deviceID,
        "groupId": groupId,
        "gateWay": gateWay,
        "lastContact": lastContact,
      };

  static getDummyContacts() {
    return [
      ContactHistory(
          contact: "user1",
          fcm: "fcm",
          totalTimeinContact: 50,
          deviceID: 1001,
          groupId: 1000),
      ContactHistory(
          contact: "user2",
          fcm: "fcm",
          totalTimeinContact: 15,
          deviceID: 2001,
          groupId: 2000),
      ContactHistory(
          contact: "user3",
          fcm: "fcm",
          totalTimeinContact: 10,
          deviceID: 3001,
          groupId: 3000),
    ];
  }
}
