// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../firebase.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.id,
    required this.superId,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.houseAddress,
    this.residenceAddress,
    this.imageUrl,
    required this.department,
    required this.userType,
    this.countryCode,
  });

  String id;
  String superId;

  String email;
  String name;
  String department;
  String? houseAddress;
  String? residenceAddress;
  String? imageUrl;
  String? countryCode;
  String? phoneNumber;
  UserType userType;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        houseAddress: json["permanentAddress"],
        residenceAddress: json["currentAddress"],
        superId: json["superId"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageUrl"],
        department: json["department"],
        userType: json["userType"] != null ? UserType.values.elementAt(json["userType"]) : UserType.localStudent,
        countryCode: json["countryCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "permanentAddress": houseAddress,
        "currentAddress": residenceAddress,
        "superId": superId,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "department": department,
        "userType": userType.index,
        "countryCode": countryCode,
      };
}

enum UserType { localStudent, foreignStudent, staff }
