import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    return Table();
  }
}

class DateTextbox extends StatelessWidget {
  DateTextbox({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  final day = TextEditingController();
  final month = TextEditingController();
  final year = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
