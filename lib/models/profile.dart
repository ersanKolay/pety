import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pety/helpers/location_helper.dart';
import 'package:pety/localization/constant_localizations.dart';
import 'package:pety/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile with ChangeNotifier {
  final db = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> _profileDataFromModels = {};

  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential _userCredential;
  User _user = FirebaseAuth.instance.currentUser;
  User get user => _user;
  Map<dynamic, dynamic> _changeDataFromModels(value) {
    print(value);

    _profileDataFromModels = value;
    notifyListeners();
    return _profileDataFromModels;
  }

  get profileDataFromModels => _profileDataFromModels;
  User _changeUser(value) {
    notifyListeners();
    return _user = value;
  }

  Future<void> _showErrorDialog(BuildContext context, String message) {
    return Fluttertoast.showToast(
        msg: getTranslated(context, message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  Future<void> getProfileData(String userId) async {
    try {
      await db.reference().child('users').child(userId).once().then((snapshot) {
        // print(snapshot.value.toString());

        // _profileDataFromModels = snapshot.value;
        _changeDataFromModels(snapshot.value);
        // notifyListeners();
        // _changeDataFromModels(snapshot.value);
      });
    } catch (error) {
      print("giden userıd" + userId);
      print("get profilde hata var");
    }
  }

  Future<void> getProfileData2(String userID) async {
    final url = 'https://pety-955f3.firebaseio.com/users/$userID.json';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
    _profileDataFromModels = extractedData;
    notifyListeners();
  }

  mailVerify() {
    return _user.emailVerified;
  }

  checkPhoneVerify() {
    //ToDo
  }
  phoneIsVerified(String phoneNumber) {
    return db.reference().child('users').child(_user.uid).update({
      'phone': phoneNumber,
      'phoneVerify': true,
    });
  }

  sendMailVerify() {
    notifyListeners();
    return _user.sendEmailVerification();
  }

  dbMailVerifyUpdate() {
    //notifyListeners();
    return db
        .reference()
        .child('users')
        .child(_user.uid)
        .update({'emailVerify': true});
  }

  dbPhoneVerifyUpdate() {
    //notifyListeners();
    return db
        .reference()
        .child('users')
        .child(_user.uid)
        .update({'emailVerify': true});
  }

  Future<void> updateSettingsPage(String username, String about) async {
    try {
      await db.reference().child('users').child(_user.uid).update({
        'username': username,
        'about': about,
      });
      getProfileData(_user.uid);
      notifyListeners();
    } catch (error) {}
  }

  ppUpdate(String url) async {
    try {
      await db
          .reference()
          .child('users')
          .child(_user.uid)
          .update({'profilePhoto': url});
      getProfileData(_user.uid);
      notifyListeners();
    } catch (error) {}
  }

  dbLocationUpdate(
    double latitude,
    double longitude,
  ) async {
    Map<dynamic, dynamic> address = await LocationHelper.getPlaceAddress(
      latitude,
      longitude,
    );
    try {
      await db.reference().child('users').child(_user.uid).update({
        'address': address['address'],
        'city': address['city'],
        'country': address['country'],
        'loc_lat': latitude,
        'loc_lng': longitude
      });
      getProfileData(_user.uid);
      notifyListeners();
    } catch (error) {}
    /* notifyListeners();
    return db.reference().child('users').child(_user.uid).update({
      'address': address['address'],
      'city': address['city'],
      'country': address['country'],
      'loc_lat': latitude,
      'loc_lng': longitude
    }); */
  }

  phoneVerify() {
    return _auth.verifyPhoneNumber(
        phoneNumber: null,
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null);
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    _changeUser(null);
  }

  login(String email, String password, BuildContext context) async {
    try {
      _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', _userCredential.user.uid);
      _changeUser(_userCredential.user);
      pushNewScreen(context, screen: HomeScreen());
    } on PlatformException catch (err) {
      print("hata var");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.message),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } catch (error) {
      if (error.code == "user-not-found") {
        _showErrorDialog(context, "user-not-found");
      } else if (error.code == "wrong-password") {
        _showErrorDialog(context, "wrong-password");
      }
    } finally {}
  }

  notifyListeners();
}
