import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    // File file = File(url);
    return GestureDetector(
      onTap: () async {
        // await launch(url, enableDomStorage: true);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 5,
        child: Container(
          height: 10,
          margin: const EdgeInsets.all(4),
          child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(18)), child: Image.network(url, fit: BoxFit.cover, width: 1000.0)),
        ),
      ),
    );
  }
}
