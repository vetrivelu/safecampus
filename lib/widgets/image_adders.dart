import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safecampus/constants/themeconstants.dart';

class ImageList extends StatefulWidget {
  const ImageList({Key? key}) : super(key: key);

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  late List<String?> items = [null];

  Future chooseFile() async {
    var files = await ImagePicker().pickMultiImage();
    if (files != null) {
      setState(() {
        if (items.isNotEmpty) items.removeLast();
        items.addAll(files.map((e) => e.path));
        items.add(null);
      });
    }
  }

  Future captureFile() async {
    var file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() {
        if (items.isNotEmpty) items.removeLast();
        items.add(file.path);
        items.add(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: items.map((e) => getItem(e)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getItem(String? path) {
    if (path != null) {
      return FileImage(
          path: path,
          onTap: () {
            setState(() {
              items.remove(path);
            });
          });
    } else {
      return NullImage(
        onTap: () {
          showModalBottomSheet(
              context: super.context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(onTap: captureFile, leading: const Icon(Icons.camera), title: const Text("Take a photo")),
                    ListTile(onTap: chooseFile, leading: const Icon(Icons.photo_album), title: const Text("Pick Images from Gallery")),
                  ],
                );
              });
          // chooseFile();
        },
      );
    }
  }
}

class NullImage extends StatelessWidget {
  const NullImage({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(12),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const AspectRatio(
            aspectRatio: 1,
            child: Icon(
              Icons.add_a_photo,
              // color: FlutterFlowTheme.primaryColor,
              size: 24,
            ),
          ),
        ),
      ),
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

class NetworkImage extends StatelessWidget {
  const NetworkImage({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    // File file = File(url);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 5,
        child: Container(
          // color: Colors.grey,
          height: 10,
          margin: const EdgeInsets.all(4),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              child: Image.network(url,
                  fit: BoxFit.fill, height: getWidth(context) * 0.25, width: getWidth(context) * 0.25, loadingBuilder: getLoadingBuilder)),
        ),
      ),
    );
  }
}

Widget getLoadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress == null) return child;
  return const Center(child: CircularProgressIndicator());
}

class Paths {
  Paths({
    required this.type,
    this.path,
  });
  String? path;
  PathType type;
}

enum PathType { url, file, noPath }
