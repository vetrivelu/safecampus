import '../firebase.dart';

class Department {
  Department({
    required this.id,
    required this.name,
    this.head,
  });

  String id;
  String name;
  String? head;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
        head: json["head"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "head": head,
      };

  static Future<Map<String, dynamic>> getDeparments() async {
    return await firestore.collection('dashboard').doc('department').get().then((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        return {"code": "failure"};
      }
    });
  }
}
