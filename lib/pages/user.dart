import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:housekeeper/main.dart';

enum login_method { none, google, facebook }

class UserInfo extends StatefulWidget {
  @override
  _UserInfo createState() => _UserInfo();
}

class _UserInfo extends State<UserInfo> {
  var loginMethod = login_method.none;
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Account>(context).user == null) {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(Buttons.Google, text: 'Google Sign in',
                    onPressed: () {
                  _signIn(context, login_method.google);
                }),
                SignInButton(Buttons.Facebook, text: 'Facebook Sign in',
                    onPressed: () {
                  _signIn(context, login_method.facebook);
                })
              ]));
    }
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              CachedNetworkImage(
                  imageUrl: Provider.of<Account>(context).user?.photoUrl ?? '',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
              Text(Provider.of<Account>(context).user.displayName,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(Provider.of<Account>(context).user.email,
                  style: TextStyle(color: Colors.white)),
              GestureDetector(
                child: Text('Logout',
                    style: TextStyle(color: Colors.yellow, fontSize: 10)),
                onTap: () {
                  _signOut(context);
                },
              )
            ])));
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _signIn(BuildContext context, login_method loginMethod) async {
    if (loginMethod == login_method.google) {
      try {
        final googleSignInAccount = await googleSignIn.signIn();
        final googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;

        Provider.of<Account>(context, listen: false).setUser(user);

        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text("Sign In ${user.uid} with Google"),
        // ));
      } catch (e) {
        print(e);
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text("Failed to sign in with Google: $e"),
        // ));
      }
    } else if (loginMethod == login_method.facebook) {
      try {
        var result = await facebookLogin.logIn(['email', 'public_profile']);
        final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;

        Provider.of<Account>(context, listen: false).setUser(user);

        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text("Sign In ${user.uid} with Facebook"),
        // ));
      } catch (e) {
        print(e);
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text("Failed to sign in with Facebook: $e"),
        // ));
      }
    }

    return 'success';
  }

  void _signOut(BuildContext context) async {
    await googleSignIn.signOut();
    Provider.of<Account>(context, listen: false).setUser(null);
  }
}
