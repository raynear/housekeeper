import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:housekeeper/main.dart';
import 'package:housekeeper/pages/user.dart';

class Menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  void _toggleLeft() {
    _innerDrawerKey.currentState.toggle(direction: InnerDrawerDirection.start);
  }

  void _toggleRight() {
    _innerDrawerKey.currentState.toggle(direction: InnerDrawerDirection.end);
  }

  @override
  Widget build(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return InnerDrawer(
        key: _innerDrawerKey,
        onTapClose: true,
        swipe: false,
        colorTransitionChild: Colors.grey,
        colorTransitionScaffold: Colors.black54,
        offset: IDOffset.only(bottom: 0.05, right: 0.0, left: 0.0),
        scale: IDOffset.horizontal(0.8),
        proportionalChildArea: true,
        borderRadius: 50,
        leftAnimationType: InnerDrawerAnimation.quadratic,
        rightAnimationType: InnerDrawerAnimation.quadratic,
        backgroundDecoration: BoxDecoration(color: Colors.blueGrey),
        // onDragUpdate: (double val, InnerDrawerDirection direction) {
        //   print(val);
        //   print(direction == InnerDrawerDirection.start);
        // },
        //innerDrawerCallback: (a) => print(a),
        leftChild: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.blueGrey,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Draw Menu',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ]))),
        rightChild: SafeArea(
          child: UserInfo(),
        ),
        scaffold: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.dehaze),
                onPressed: () {
                  _toggleLeft();
                },
              ),
              title:
                  Text('housekeeper', style: GoogleFonts.getFont('Pacifico')),
              actions: [
                (Provider.of<Account>(context).user?.photoURL ?? '') != ''
                    ? IconButton(
                        onPressed: () {
                          _toggleRight();
                        },
                        icon: CircleAvatar(
                            radius: appBarHeight * 1.0,
                            backgroundColor: Colors.teal[200],
                            child: CircleAvatar(
                              radius: appBarHeight * 0.9,
                              backgroundImage: CachedNetworkImageProvider(
                                Provider.of<Account>(context).user?.photoURL ??
                                    '',
                              ),
                            )))
                    : GestureDetector(
                        onTap: () {
                          _toggleRight();
                        },
                        child: SafeArea(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Sign in')]))))
              ],
            ),
            body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Menu'),
                    RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/house_list');
                        },
                        child: Text('go to list'))
                  ]),
            )));
  }
}
