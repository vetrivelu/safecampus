import 'package:get/get.dart';
import 'package:safecampus/models/department.dart';

import '../firebase.dart';

class Dashboard extends GetxController {
  static Dashboard instance = Get.find();
  List<dynamic> carouselItems = [];
  List<Department> departments = [];
  Map<String, dynamic> locations = {};

  String getLocation({required String gateway}) {
    return locations[gateway]?['name'] ?? gateway;
  }

  String? getName(String? id) {
    if (id == null) {
      return null;
    }
    try {
      var department = departments.firstWhere((element) => element.id == id);
      return department.name;
    } catch (e) {
      return null;
    }
  }

  @override
  onInit() {
    super.onInit();
    loadCaruosel();
    loadDepartments();
    loadLocations();
  }

  loadLocations() {
    firestore.collection('dashboard').doc('location').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        locations = snapshot.data()!;
      }
      update();
    });
  }

  loadCaruosel() {
    firestore.collection('dashboard').doc('carousel').snapshots().listen((snapshot) {
      var urls = snapshot.data()?["imageUrl"];
      carouselItems = urls ?? [];
      // print(carouselItems);
      update();
    });
  }

  // departments = snapshot.data()!.values.toList();

  loadDepartments() {
    firestore.collection('dashboard').doc('departments').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        departments = snapshot.data() != null ? snapshot.data()!.values.map((e) => Department.fromJson(e)).toList() : departments;
        update();
      }
    });
  }
}

Dashboard dashboard = Dashboard.instance;
