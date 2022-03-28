// ignore_for_file: avoid_print

import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:safecampus/constants/themeconstants.dart';
import 'package:safecampus/controllers/auth_controller.dart';
import 'package:safecampus/controllers/dashboard_controller.dart';

import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/screens/notiifcationlist.dart';
import 'package:safecampus/screens/profile/profile.dart';

import 'package:safecampus/widgets/network_image.dart';
import 'package:safecampus/widgets/tile_home.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../main.dart';
import 'announcementpage.dart';
import 'announcements_list.dart';
import 'assessments/assesment_list.dart';
import 'contact_list.dart';
import 'notificationpage.dart';
import 'quarantine.dart';
import 'status/covid_history.dart';
import 'whistleblower.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _getToken() {
    userController.updateToken();
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        if (message.notification != null) {
          print(message.notification!.body);
          print(message.notification!.title);
          print("message");

          if (message.notification!.title == "Contact Registered") {
            Get.to(() => ContactHistoryDetails());
          } else if (message.notification!.title ==
              "You have been quarantined") {
            Get.to(() => QuarantinePage(user: userController.user!));
          } else {
            Get.to(() => const AnnouncementList());
          }
        }
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
            1,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description)));
        var preferences = await prefs;
        preferences.setStringList(
            DateTime.now().toIso8601String().substring(0, 19) + ".000000", [
          message.notification!.body.toString(),
          message.notification!.title.toString()
        ]);
        print(message.notification!.body);
        print(message.notification!.title);
        print("message");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (message.notification != null) {
        var preferences = await prefs;
        preferences.setStringList(DateTime.now().toIso8601String(), [
          message.notification!.body.toString(),
          message.notification!.title.toString()
        ]);
        print(message.notification!.body);
        print(message.notification!.title);
        print("message");

        if (message.notification!.title == "Contact Registered") {
          Get.to(() => ContactHistoryDetails());
        } else if (message.notification!.title == "You have been quarantined") {
          Get.to(() => QuarantinePage(user: userController.user!));
        } else {
          Get.to(() => const AnnouncementList());
        }
      }
    });

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true);
    _firebaseMessaging.subscribeToTopic('Announcement');
    _firebaseMessaging.subscribeToTopic('Assessment');

    _getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.red[100],
                title: Column(
                  children: [
                    Image.asset("assets/icon/iuicon2.png"),
                    const Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                content: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Are you sure you wish to logout?'),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () {
                            auth.signOut();
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Color(0xFFED392D),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.circle_notifications_outlined,
                size: 30,
              ),
              color: const Color(0xFFED392D),
              onPressed: () {
                Get.to(() => const NotificationList());
              },
            ),
          )
        ],
        title: Padding(
          padding:
              const EdgeInsets.only(left: 48, right: 56, top: 48, bottom: 48),
          child: Image.asset(
            'assets/images/iukl_logo.png',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GetBuilder(
                init: dashboard,
                builder: (context) {
                  return CarouselSlider(
                    options: CarouselOptions(
                        height: 220,
                        autoPlay: true,
                        aspectRatio: 4 / 3,
                        autoPlayInterval: const Duration(seconds: 10)),
                    items: dashboard.carouselItems
                        .map((element) => CustomNetworkImage(url: element))
                        .toList(),
                  );
                }),
          ),
          const Divider(),
          PaddedText("Menu",
              style: getText(context)
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold)),
          Wrap(
            direction: Axis.horizontal,
            children: [
              Tile(
                title: 'Status',
                image: 'assets/images/high-fever-512x512-1833393.png',
                onTap: () {
                  Get.to(() => const CovidList());
                },
              ),
              Tile(
                title: 'History',
                image: 'assets/images/ContactHistory.png',
                onTap: () {
                  Get.to(() => ContactHistoryDetails());
                },
              ),
              Tile(
                title: 'Solitary',
                image: 'assets/images/virus-protection-512x512-1833388.png',
                onTap: () {
                  Get.to(() => QuarantinePage(
                        user: userController.user!,
                      ));
                },
              ),
              Tile(
                title: 'Complaint',
                image: 'assets/images/whistle blower.png',
                onTap: () {
                  Get.to(() => WhistleBlower());
                },
              ),
              Tile(
                title: 'Bulletin',
                image: 'assets/images/announcement.png',
                onTap: () {
                  Get.to(() => const AnnouncementList());
                },
              ),
              Tile(
                title: 'Profile',
                image: 'assets/images/profile.png',
                onTap: () {
                  Get.to(() => const ProfilePage());
                },
              ),
              Row(
                children: [
                  GetBuilder(
                      init: userController,
                      builder: (context) {
                        return Badge(
                          showBadge:
                              userController.pendingAssesmentList.isNotEmpty,
                          badgeContent: Text(userController
                              .pendingAssesmentList.length
                              .toString()),
                          child: Tile(
                            title: 'Assesments',
                            image: 'assets/images/profile.png',
                            onTap: () {
                              Get.to(() => AssessmentList());
                            },
                          ),
                        );
                      }),
                  // Expanded(
                  //     child: Card(
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  //   child: SizedBox(
                  //     height: (getWidth(context) / 3) - 16,
                  //     child: const Center(
                  //         // child: ElevatedButton(
                  //         //     onPressed: () {
                  //         //       functions
                  //         //           .httpsCallable('addUser')
                  //         //           .call({"email": "test@gmail.com", "password": "12345678", "user": userController.user!.toJson()});
                  //         //     },
                  //         //     child: const Text("Test")),
                  //         // child: Padding(
                  //         //   padding: EdgeInsets.all(8.0),
                  //         //   child: Text("Location status : \nYou need to have a device assigned to get the location"),
                  //         // ),
                  //         ),
                  //   ),
                  // ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaddedText extends StatelessWidget {
  const PaddedText(this.text, {Key? key, this.style}) : super(key: key);

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
