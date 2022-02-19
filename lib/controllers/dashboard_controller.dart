import 'package:get/get.dart';

import '../firebase.dart';

class Dashboard extends GetxController {
  static Dashboard instance = Get.find();
  List<dynamic> carouselItems = [];
  List<dynamic> departments = [];
  Map<String, dynamic> locations = {};

  @override
  onInit() {
    super.onInit();
    loadCaruosel();
    loadDepartments();
    loadLocations();
  }

  loadLocations() {
    firestore
        .collection('dashboard')
        .doc('Location')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        locations = snapshot.data()!;
      }
      update();
    });
  }

  loadCaruosel() {
    firestore
        .collection('dashboard')
        .doc('carousel')
        .snapshots()
        .listen((snapshot) {
      var urls = snapshot.data()?["imageUrl"];
      carouselItems = urls ?? [];
      // print(carouselItems);
      update();
    });
  }

  // departments = snapshot.data()!.values.toList();

  loadDepartments() {
    firestore
        .collection('dashboard')
        .doc('Departments')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        departments = snapshot.data() != null
            ? snapshot.data()!.values.toList()
            : departments;
        update();
      }
    });
  }
}

Dashboard dashboard = Dashboard.instance;
