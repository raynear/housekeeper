import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:housekeeper/pages/user/user_avatar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Drawer Test')]))),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text('housekeeper', style: GoogleFonts.getFont('Pacifico')),
          actions: [UserAvatar()],
        ),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Menu'),
                RaisedButton(
                    onPressed: () {
                      Get.toNamed('/house_list');
                    },
                    child: Text('go to list'))
              ]),
        ));
  }
}
