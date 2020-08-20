import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';

enum login_method { none, google, facebook }

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var loginMethod = login_method.none;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (user.value == null) {
        return Scaffold(
            appBar: AppBar(title: Text('Sign in')),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
          appBar: AppBar(title: Text('Sign in')),
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                CachedNetworkImage(
                    imageUrl: user.value?.photoURL ?? '',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error)),
                Text(user.value.displayName,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent)),
                Text(user.value.email, style: TextStyle(color: Colors.black)),
                GestureDetector(
                  child: Text('Logout',
                      style: TextStyle(color: Colors.yellow, fontSize: 10)),
                  onTap: () {
                    _signOut(context);
                  },
                )
              ])));
    });
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

        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final authResult = await _auth.signInWithCredential(credential);
        user.value = authResult.user;

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
        final credential =
            FacebookAuthProvider.credential(result.accessToken.token);
        final authResult = await _auth.signInWithCredential(credential);
        user.value = authResult.user;

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
    user.value = null;
  }
}
