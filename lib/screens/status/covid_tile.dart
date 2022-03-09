import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safecampus/constants/colors.dart';
import 'package:safecampus/models/user.dart';

final format = DateFormat.yMMMMd('en_US');

class CovidTile extends StatelessWidget {
  const CovidTile({
    Key? key,
    required this.covidInfo,
  }) : super(key: key);

  final CovidInfo covidInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            // textBaseline: TextBaseline.alphabetic,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2)},
            children: [
              TableRow(
                children: [
                  const Text("Test Date"),
                  Text(": ${format.format(covidInfo.date!)}"),
                  Container(
                    height: 20,
                    width: 60,
                    child: Center(
                      child: Text(
                        covidInfo.result == false ? 'Negative' : 'Positive',
                        style: TextStyle(fontWeight: FontWeight.bold, color: cardcolor),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: covidInfo.result == false ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  )
                ],
              ),
              TableRow(
                children: [
                  const Text("Test Method"),
                  Text(": ${covidInfo.method.toString()}"),
                  Container(
                    height: 25,
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Text("Vaccination Date"),
                  Text(": ${covidInfo.vaccinated ? format.format(covidInfo.vaccinatedOn!) : "Not vaccinated"} "),
                  Container()
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
