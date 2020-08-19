import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:housekeeper/pages/menu.dart';
import 'package:housekeeper/pages/house_list.dart';

void main() {
  runApp(MyApp());
}

class Account with ChangeNotifier {
  User _user; // = await FirebaseAuth.instance.currentUser();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider<Account>(create: (_) => Account())
          ],
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
    } else {
      return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(child: Text('Loading...'))])));
    }
  }
}
