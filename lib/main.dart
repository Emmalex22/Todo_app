import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/controller.dart';
import 'package:todo_app/app/home.dart';

void main() {
  Get.put(Controller());
  runApp(const RestApiDemo());
}
class RestApiDemo extends StatelessWidget {
  const RestApiDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(useMaterial3: false),
      home: Home(),
    );
  }
}