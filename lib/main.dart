import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:housekeeper/pages/menu.dart';
import 'package:housekeeper/pages/house_list.dart';

void main() {
  runApp(MyApp());
}

class Account with ChangeNotifier {
  FirebaseUser _user; // = await FirebaseAuth.instance.currentUser();

  FirebaseUser get user => _user;

  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider<Account>(create: (_) => Account())],
        child: MaterialApp(
          title: 'housekeeper',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/house_list',
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => Menu(),
            '/house_list': (BuildContext context) => HouseList(),
          },
        ));
  }
}
