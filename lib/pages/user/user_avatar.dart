import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:housekeeper/global_state.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - Get.mediaQuery.padding.top;
    return Obx(() {
      return (user.value?.photoURL ?? '') != ''
          ? IconButton(
              onPressed: () {
                print('go to user info');
              },
              icon: CircleAvatar(
                  radius: appBarHeight * 1.0,
                  backgroundColor: Colors.teal[200],
                  child: CircleAvatar(
                    radius: appBarHeight * 0.9,
                    backgroundImage: CachedNetworkImageProvider(
                      user.value?.photoURL ?? '',
                    ),
                  )))
          : GestureDetector(
              onTap: () {
                print('goto login');
                Get.toNamed('/sign_in');
              },
              child: SafeArea(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Sign in')]))));
    });
  }
}
