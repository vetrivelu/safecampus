import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:pert/models/profile_model.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:safecampus/controllers/dashboard_controller.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/models/profile.dart';
import 'package:safecampus/screens/profile/profile_form.dart';
// import 'package:fluttericon/entypo_icons.dart';
// import 'package:fluttericon/elusive_icons.dart';

const String url =
    'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    userController.listenProfile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            Navigator.of(context).pop();
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.arrow_back_ios),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: // Generated code for this Column Widget...

            GetBuilder(
                init: userController,
                builder: (_) {
                  return SingleChildScrollView(
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Material(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  decoration: const BoxDecoration(
                                    // color: Color(0xFFED392D),
                                    gradient: LinearGradient(
                                      tileMode: TileMode.clamp,
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.white,
                                        Colors.red,
                                      ],
                                    ),

                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                        child: Material(
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Hero(
                                            tag: "avatar",
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: userController.user!
                                                          .bioData.imageUrl !=
                                                      null
                                                  ? Image.network(
                                                      userController.user!
                                                          .bioData.imageUrl!,
                                                      fit: BoxFit.fitHeight,
                                                    )
                                                  : const Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 100,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          userController.user!.bioData.name,
                                          style: const TextStyle(

                                              // color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Text(
                                          userController.user!.bioData.id,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        dashboard.getName(userController
                                                .user!.bioData.department) ??
                                            "Not Assigned",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            shadows: [Shadow(blurRadius: 2)]),
                                      )),
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 0),
                            child: ListTile(
                              trailing: SizedBox(
                                width: 150,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const ProfileForm());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.edit),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Edit Profile')
                                    ],
                                  ),
                                ),
                              ),
                              dense: false,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.person_outline_outlined),
                            title: const Text(
                              'Name',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                userController.user!.bioData.name,
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(FontAwesome5.id_badge),
                            title: const Text(
                              'ID',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                userController.user!.bioData.id,
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(FontAwesome5.passport),
                            title: Text(
                              userController.user!.bioData.userType ==
                                      UserType.foreignStudent
                                  ? 'Passport Number'
                                  : "IC Number",
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                userController.user!.bioData.superId,
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                                Icons.supervised_user_circle_outlined),
                            title: const Text(
                              'Department',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                dashboard.getName(userController
                                        .user!.bioData.department) ??
                                    "Not Assigned",
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text(
                              'Phone Number',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "${userController.user!.bioData.countryCode} ${userController.user!.bioData.phoneNumber!}",
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.house),
                            title: const Text(
                              'House Address',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                userController.user!.bioData.houseAddress!,
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ListTile(
                              leading: const Icon(Icons.location_city_outlined),
                              title: const Text(
                                'Residence Address',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  userController
                                      .user!.bioData.residenceAddress!,
                                  style: const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              dense: true,
                            ),
                          ),
                          const Divider(),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 20),
                          //   child: ListTile(
                          //     leading: const Icon(Icons.location_city_outlined),
                          //     title: const Text(
                          //       'Device ID',
                          //       style: TextStyle(
                          //         fontFamily: 'Lexend Deca',
                          //         color: Colors.black,
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     subtitle: Padding(
                          //       padding: const EdgeInsets.only(top: 10),
                          //       child: Text(
                          //         (userController.user!.device?.deviceId).toString(),
                          //         style: const TextStyle(
                          //           fontFamily: 'Lexend Deca',
                          //           color: Colors.black,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.normal,
                          //         ),
                          //       ),
                          //     ),
                          //     dense: true,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                }));
  }
}
