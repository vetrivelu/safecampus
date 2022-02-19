import 'package:flutter/material.dart';

getHeight(BuildContext context) => MediaQuery.of(context).size.height;
getWidth(BuildContext context) => MediaQuery.of(context).size.width;
TextTheme getText(BuildContext context) => Theme.of(context).textTheme;

getAppBar(context) => AppBar(
      centerTitle: true,
      title: SizedBox(height: getHeight(context) * 0.15, child: Image.asset('assets/bina.png')),
    );
