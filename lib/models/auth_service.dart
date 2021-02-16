import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential _userCredential;
  bool _emailVerified;
  bool get emailVerified {
    print(_emailVerified);
    return _emailVerified;
  }

  UserCredential get userCredential {
    return _userCredential;
  }

  FirebaseAuth get auth {
    return _auth;
  }

  Future<void> login(String email, String password) async {
    try {
      _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', _userCredential.user.uid);
      print(_userCredential.user.uid);
      /*   pushNewScreen(
        context,
        screen: TabsScreen(
          menuScreenContext: context,
        ),
      ); */
    } catch (error) {}
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('id')) {
      return false;
    }
    return true;
  }

  verifyMail() {
    _emailVerified = _auth.currentUser.emailVerified;
  }
}
