import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/models/assessment.dart';
import 'package:safecampus/screens/assessments/takeAssesment.dart';

class AssessmentList extends StatelessWidget {
  const AssessmentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assessments")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: Assessment.getAssesments(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text('Error!');
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var assessment = Assessment.fromJson(snapshot.data!.docs[index].data());
                  var Ids = (userController.user!.assessments ?? []).map((e) => e.id).toList();
                  return Ids.contains(assessment.id)
                      ? Container()
                      : Card(
                          child: ListTile(
                              title: Text(assessment.title),
                              onTap: () {
                                Get.to(() => TakeAssesment(assessment: assessment));
                              }),
                        );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
