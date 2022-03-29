import 'package:get/get.dart';
import 'package:safecampus/controllers/profile_controller.dart';
import 'package:safecampus/routers/auth_router.dart';
import 'package:safecampus/screens/announcements_list.dart';
import 'package:safecampus/screens/profile/profile.dart';
import 'package:safecampus/screens/quarantine.dart';

class Routes {
  static final routes = [
    GetPage(name: '/', page: () => const AuthRouter()),
    GetPage(name: '/profile', page: () => const ProfilePage()),
    GetPage(
        name: '/quarantine',
        page: () => QuarantinePage(user: userController.user!)),
    GetPage(name: '/announcementlist', page: () => const AnnouncementList()),
  ];
}
