import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safecampus/constants/colors.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/models/user.dart';
import 'package:table_calendar/table_calendar.dart';

class QuarantinePage extends StatefulWidget {
  const QuarantinePage({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  // final Quarantine quarantine;
  @override
  _QuarantinePageState createState() => _QuarantinePageState();
}

class _QuarantinePageState extends State<QuarantinePage> {
  @override
  void initState() {
    super.initState();
    userController.loadQuarantine();
  }

  int get daysLeft =>
      userController.user!.quarantine!.endDate
          .difference(DateTime.utc(
              DateTime.now().year, DateTime.now().month, DateTime.now().day))
          .inDays +
      1;

  Quarantine? get quarantine => widget.user.quarantine;

  // int get daysLeft =>
  //     DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day).difference(userController.user!.quarantine!.endDate).inDays;

  List<TableRow> getChildren() {
    List<TableRow> list = [];
    if (quarantine != null) {
      if (quarantine!.location.inCampus == true) {
        if (quarantine!.location.place != null) {
          list.add(TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Building Name"),
            ),
            const Text(":"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(quarantine!.location.place!),
            )
          ]));
        }
        if (quarantine!.location.block != null) {
          list.add(TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Block"),
            ),
            const Text(":"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(quarantine!.location.block!),
            )
          ]));
        }
        if (quarantine!.location.roomNumbmer != null) {
          list.add(TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Room Number"),
            ),
            const Text(":"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(quarantine!.location.roomNumbmer!),
            )
          ]));
        }
      } else {
        if (quarantine!.location.outCampus != null) {
          list.add(TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Location"),
            ),
            const Text(":"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(quarantine!.location.outCampus!),
            )
          ]));
        }
      }
      if (quarantine!.location.quarantineAddress != null) {
        list.add(TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Address"),
          ),
          const Text(":"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(quarantine!.location.quarantineAddress!),
          )
        ]));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // final date =widget.user.quarantine!;
    return GetBuilder(
        init: userController,
        builder: (_) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: const Text('Solitary History'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime.utc(2015),
                        lastDay: DateTime.utc(2023),
                        rangeStartDay:
                            userController.user!.quarantine?.startDate,
                        rangeEndDay: userController.user!.quarantine?.endDate,
                        headerStyle:
                            const HeaderStyle(formatButtonVisible: false),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: widget.user.quarantine != null
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEC4338),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("$daysLeft",
                                        style: const TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const Text("days left",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your Recent Residence History',
                        style: TextStyle(
                          color: kprimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(6),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: getChildren(),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   'Quarantine History',
                      //   style: TextStyle(
                      //     color: Colors.grey[700],
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: Card(
                      //     color: kprimaryColor,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children: [
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               SizedBox(
                      //                 height: 40,
                      //                 child: RichText(
                      //                   maxLines: 5,
                      //                   text: const TextSpan(
                      //                       text: 'Address : ',
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           color: Colors.white),
                      //                       children: [
                      //                         TextSpan(
                      //                           text: 'Sample Adddress',
                      //                           style: TextStyle(
                      //                               fontWeight: FontWeight.normal,
                      //                               color: Colors.white),
                      //                         )
                      //                       ]),
                      //                 ),
                      //               ),
                      //               RichText(
                      //                 text: const TextSpan(
                      //                     text: 'Block : ',
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold,
                      //                         color: Colors.white),
                      //                     children: [
                      //                       TextSpan(
                      //                         text: '5A',
                      //                         style: TextStyle(
                      //                             fontWeight: FontWeight.normal,
                      //                             color: Colors.white),
                      //                       )
                      //                     ]),
                      //               ),
                      //             ],
                      //           ),
                      //           const Spacer(),
                      //           Column(
                      //             children: const [
                      //               Padding(
                      //                 padding: EdgeInsets.all(8.0),
                      //                 child: Icon(
                      //                   Icons.calendar_today,
                      //                   size: 30,
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 '20/10/2021',
                      //                 style: TextStyle(
                      //                     color: Colors.white, fontSize: 16),
                      //               ),
                      //               Text(
                      //                 '28/10/2021',
                      //                 style: TextStyle(
                      //                     color: Colors.white, fontSize: 16),
                      //               ),
                      //               Text(
                      //                 'Duration : 5 days',
                      //                 style: TextStyle(
                      //                     color: Colors.white, fontSize: 16),
                      //               ),
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
