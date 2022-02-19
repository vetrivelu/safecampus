import 'package:flutter/material.dart';
import 'package:safecampus/constants/themeconstants.dart';

class Tile extends StatelessWidget {
  final String? title;
  final String? image;
  final void Function()? onTap;
  const Tile({Key? key, this.title, this.image, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context) / 3,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: onTap,
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 5,
              child: GridTile(
                footer: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(35.0),
                  child: Image.asset(
                    image!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
