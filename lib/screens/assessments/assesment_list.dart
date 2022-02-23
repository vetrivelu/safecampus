import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/screens/assessments/take_assesment.dart';

class AssessmentList extends StatelessWidget {
  AssessmentList({Key? key}) : super(key: key);
  final DateFormat formatter = DateFormat.yMMMMd('en_US');
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Assessments"),
            bottom: const TabBar(tabs: [
              Tab(
                text: "Pending Assesments",
              ),
              Tab(
                text: "Completed Assesments",
              ),
            ]),
          ),
          body: GetBuilder(
              init: userController,
              builder: (_) {
                return TabBarView(
                  children: [
                    userController.pendingAssesmentList.isEmpty
                        ? const Center(
                            child: Text("You are all caught up. No Pending Assesments"),
                          )
                        : ListView.builder(
                            itemCount: userController.pendingAssesmentList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                    title: Text(userController.pendingAssesmentList[index].title),
                                    subtitle: Text('Created on : ' + formatter.format(userController.pendingAssesmentList[index].createdDate)),
                                    onTap: () {
                                      Get.to(() => TakeAssesment(
                                            assessment: userController.pendingAssesmentList[index],
                                            canEdit: true,
                                          ));
                                    }),
                              );
                            }),
                    ListView.builder(
                        itemCount: userController.user!.assessments?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                            title: Text(userController.user!.assessments![index].title),
                            onTap: () {
                              Get.to(() => TakeAssesment(
                                    assessment: userController.user!.assessments![index],
                                    canEdit: false,
                                  ));
                            },
                          ));
                        }),
                  ],
                );
              })),
    );
  }
}
