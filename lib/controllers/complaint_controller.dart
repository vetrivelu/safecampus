import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController {
  File? _file;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  clear() {
    _file = null;
    title.clear();
    description.clear();
    update();
  }

  File? get file => _file;
  set file(File? f) {
    _file = f;
    update();
  }
}
