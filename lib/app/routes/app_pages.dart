// lib/app_pages.dart
import 'package:get/get.dart';
import 'app_routes.dart';
import 'package:todo_app/app/home.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => Home(),
    ),
  ];
}
