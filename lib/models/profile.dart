// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);
import 'dart:convert';

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

  List<String> get searchString {
    List<String> list = [];
    List<String> splits = name.split(' ').toList();
    splits.forEach((element) {
      list.addAll(makeSearchstring(element));
    });
    return list;
  }

  List<String> makeSearchstring(String string) {
    List<String> list = [];
    for (int i = 1; i < string.length; i++) {
      list.add(string.substring(0, i).toLowerCase());
    }
    list.add(string.toLowerCase());
    return list;
  }

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
