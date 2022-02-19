import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/screens/assessments/takeAssesment.dart';

class AssessmentList extends StatelessWidget {
  const AssessmentList({Key? key}) : super(key: key);

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
                                    onTap: () {
                                      Get.to(() => TakeAssesment(assessment: userController.pendingAssesmentList[index]));
                                    }),
                              );
                            }),
                    ListView.builder(
                        itemCount: userController.user!.assessments?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                            title: Text(userController.user!.assessments![index].title),
                            // subtitle: Text(userController.user!.assessments![index].createdDate.toString()),
                            // onTap: () {
                            //   Get.to(() => TakeAssesment(assessment: userController.user!.assessments![index]));
                            // }),
                          ));
                        }),
                  ],
                );
              })),
    );
  }
}
