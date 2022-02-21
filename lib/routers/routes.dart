import 'package:get/get.dart';
import 'package:safecampus/routers/auth_router.dart';
import 'package:safecampus/screens/profile/profile.dart';

class Routes {
  static final routes = [GetPage(name: '/', page: () => const AuthRouter()), GetPage(name: '/profile', page: () => const ProfilePage())];
}
