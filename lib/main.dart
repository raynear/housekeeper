import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'package:housekeeper/pages/main_page.dart';
import 'package:housekeeper/pages/user/sign_in.dart';
import 'package:housekeeper/pages/house/house_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'housekeeper',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => MainPage(),
            transitionDuration: Duration(milliseconds: 100),
            transition: Transition.native),
        GetPage(
            name: '/house_list',
            page: () => HouseList(),
            curve: Curves.bounceIn,
            transitionDuration: Duration(milliseconds: 100),
            transition: Transition.native),
        GetPage(
            name: '/sign_in',
            page: () => SignIn(),
            transitionDuration: Duration(milliseconds: 100),
            transition: Transition.native),
      ],
    );
  }
}
