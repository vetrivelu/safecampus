import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safecampus/constants/themeconstants.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/screens/status/covid_tile.dart';
import 'package:safecampus/screens/status/covid_update.dart';

final format = DateFormat.yMMMMd('en_US');

class CovidList extends StatelessWidget {
  const CovidList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Covid History"),
          centerTitle: true,
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        SizedBox(height: getHeight(context) * 0.75, child: const CovidForm()),
                      ],
                    );
                  });
            },
            child: const Text("Add Report")),
        body: GetBuilder(
            init: userController,
            builder: (context) {
              if (userController.user!.covidHistory!.isEmpty) {
                return const Center(
                  child: Text("No Records Found"),
                );
              } else {
                return ListView.builder(
                    itemCount: userController.user!.covidHistory?.length,
                    itemBuilder: (context, index) {
                      return CovidTile(
                        covidInfo: userController.user!.covidHistory![index],
                        onTap: () {
                          userController.removeCovidInfo(index);
                        },
                      );
                      // return Card(
                      //     child: Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Table(
                      //     children: [
                      //       userController.user!.covidHistory![index].method !=
                      //               null
                      //           ? TableRow(children: [
                      //               const Padding(
                      //                 padding: EdgeInsets.all(8.0),
                      //                 child: Text(
                      //                   "Test Method",
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Text(userController
                      //                     .user!.covidHistory![index].method!),
                      //               ),
                      //             ])
                      //           : doNothing(),
                      //       TableRow(children: [
                      //         const Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "Test Date",
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(format.format(userController
                      //               .user!.covidHistory![index].date!)),
                      //         ),
                      //       ]),
                      //       TableRow(children: [
                      //         const Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "Result",
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(userController
                      //                   .user!.covidHistory![index].result
                      //               ? "Positive"
                      //               : "Negative"),
                      //         ),
                      //       ]),
                      //       TableRow(children: [
                      //         const Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "Vaccination Date",
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(userController
                      //                   .user!.covidHistory![index].vaccinated
                      //               ? format.format(userController.user!
                      //                   .covidHistory![index].vaccinatedOn!)
                      //               : "Not yet Vaccinated"),
                      //         ),
                      //       ]),
                      //     ],
                      //   ),
                      // ));
                    });
              }
            }));
  }
}

doNothing() {}
