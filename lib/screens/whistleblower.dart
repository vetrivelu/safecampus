import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:safecampus/controllers/complaint_controller.dart';
import 'package:safecampus/models/complaint.dart';
import 'package:safecampus/widgets/custom_textbox.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:badges/badges.dart';
import 'package:safecampus/widgets/dialog.dart';
import 'package:safecampus/widgets/image_adders.dart';

class WhistleBlower extends StatelessWidget {
  WhistleBlower({Key? key}) : super(key: key);

  final ComplaintController controller = Get.put(ComplaintController());

  Future chooseFile() async {
    var xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      controller.file = File(xfile.path);
    }
  }

  Future chooseFiles() async {
    List<XFile>? xfiles = await ImagePicker().pickMultiImage();
    if (xfiles != null && xfiles.isNotEmpty) {
      controller.files = xfiles.map((e) => File(e.path)).toList();
      controller.update();
    }
  }

  Future captureFile() async {
    var xfile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xfile != null) {
      controller.files.add(File(xfile.path));
      controller.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaint"), centerTitle: true),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(onTap: captureFile, leading: const Icon(Icons.camera), title: const Text("Take a photo")),
                          ListTile(onTap: chooseFiles, leading: const Icon(Icons.photo_album), title: const Text("Pick Images from Gallery")),
                        ],
                      );
                    });
              },
              child: const Icon(Icons.add_a_photo),
              heroTag: '',
            ),
          ),
          // const Text("Add Image"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                var future =
                    Complaint.createComplaint(description: controller.description.text, title: controller.title.text, files: controller.files);
                showFutureDialog(
                    context: context,
                    future: future,
                    onFailure: () {
                      Navigator.of(context).pop();
                    },
                    onSuccess: () {
                      controller.clear();
                      Navigator.of(context).pop();
                    });
              },
              child: const Icon(Icons.upload),
              heroTag: '_',
            ),
          ),
          // const Text("Submit"),
        ],
      ),
      body: GetBuilder(
          init: controller,
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    ModernPictograms.bullhorn,
                    size: 100,
                  ),
                  const Divider(),
                  CustomTextBox(controller: controller.title, labelText: "Title", hintText: "Enter title"),
                  CustomTextBox(
                    controller: controller.description,
                    labelText: "Description",
                    hintText: "Enter description",
                    maxLines: 6,
                  ),
                  const Divider(),

                  Wrap(
                    children: controller.files
                        .map((e) => FileImage(
                              path: e.path,
                              onTap: () {
                                controller.files.removeWhere((element) => element.path == e.path);
                                controller.update();
                              },
                            ))
                        .toList(),
                  ),
                  // controller.file == null
                  //     ? Container()
                  //     : Expanded(
                  //         child: Align(
                  //           alignment: Alignment.topCenter,
                  //           child: Badge(
                  //               badgeContent: GestureDetector(
                  //                 onTap: () {
                  //                   controller.file = null;
                  //                 },
                  //                 child: const Icon(Icons.cancel, color: Colors.white),
                  //               ),
                  //               child: Image.file(controller.file!)),
                  //         ),
                  // child: FileImage(
                  // path: controller.file!.path,
                  // onTap: () {
                  //   controller.file = null;
                  // },
                  // ),
                ],
              ),
            );
          }),
    );
  }
}

class FileImage extends StatelessWidget {
  const FileImage({
    Key? key,
    required this.path,
    this.onTap,
  }) : super(key: key);
  final String path;

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(File(path)),
            ),
            Positioned(
              top: 1,
              right: 1,
              child: GestureDetector(onTap: onTap, child: const Icon(Icons.cancel)),
            )
          ],
        ),
      ),
    );
  }
}
