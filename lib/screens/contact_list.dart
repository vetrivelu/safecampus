import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safecampus/controllers/profile_controller.dart';

import '../controllers/dashboard_controller.dart';

class ContactHistoryDetails extends StatelessWidget {
  ContactHistoryDetails({Key? key}) : super(key: key);

  final format = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon History'),
        centerTitle: true,
      ),
      body: GetBuilder(
          init: userController,
          builder: (context) {
            return Column(
              children: <Widget>[
                userController.user!.contactHistory == null
                    ? const Expanded(child: Center(child: Text("No Contact History Found")))
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: userController.user!.contactHistory != null ? userController.user!.contactHistory!.length : 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFAF2922),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 10, 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextForDetails(
                                          data: 'Beacon Holder Name : ${userController.user!.contactHistory![index].contact}',
                                        ),
                                        TextForDetails(
                                          data: 'Group ID : ${userController.user!.contactHistory![index].groupId}',
                                        ),
                                        TextForDetails(
                                          data: 'Device ID : ${userController.user!.contactHistory![index].deviceID}',
                                        ),
                                        TextForDetails(
                                          data: 'Date & Time :${format.format(userController.user!.contactHistory![index].lastContact!)}',
                                        ),
                                        TextForDetails(
                                            data:
                                                'Location: ${dashboard.getLocation(gateway: userController.user!.contactHistory![index].gateWay ?? '')}'),
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            );
          }),
    );
  }
}

class TextForDetails extends StatelessWidget {
  const TextForDetails({
    Key? key,
    this.data,
  }) : super(key: key);
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      style: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white,
        fontSize: 15,
      ),
    );
  }
}
