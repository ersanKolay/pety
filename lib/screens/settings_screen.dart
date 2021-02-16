import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pety/models/place_location.dart';
import 'package:pety/models/profile.dart';
import 'package:pety/widgets/change_profile_photo.dart';
import 'package:pety/widgets/location_input.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  Map<dynamic, dynamic> _iniValues = {};
  Timer _timer;
  bool _mailVerify, _checkStatus = false;
  bool _phoneVerify;
  String phoneNumber, verificationId, smsCode;
  String _username, _about;
  get phoneVerifiedSuccess => null;

  PlaceLocation _pickedLocation;
  @override
  void initState() {
    _timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => checkIfEmailIsVerified());
    super.initState();
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    return null;
  }

  Future<void> verifyPhone() async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authCredential) {};
    final PhoneVerificationFailed failed =
        (FirebaseAuthException authExcepiton) {
      print(authExcepiton.message);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResen]) {
      this.verificationId = verId;
      smsCodeDialoge(context).then((value) {});
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: failed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    FirebaseAuth.instance.currentUser
        .linkWithCredential(credential)
        .then((user) {
      Provider.of<Profile>(context, listen: false).phoneIsVerified(phoneNumber);
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> smsCodeDialoge(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      useRootNavigator: false,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              maxLength: 6,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                this.smsCode = value;
              },
              decoration: InputDecoration(
                labelText: "sms code",
                hintText: "123456",
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                signIn(smsCode);

                Navigator.pop(context);
              },
              color: Colors.blue,
              child: Text(
                "verify",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkIfEmailIsVerified() async {
    if (_mailVerify == true) {
      setState(() {});
      return Provider.of<Profile>(context, listen: false).dbMailVerifyUpdate();
    }
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.currentUser.reload();
    User _user = _auth.currentUser;
    _mailVerify = _user.emailVerified;

    setState(() {});
  }

  _sendMailVerify() {
    return Provider.of<Profile>(context, listen: false).sendMailVerify();
  }

  Future<void> _updateSettingsPage() async {
    final _isValid = _form.currentState.validate();

    if (!_isValid) {
      return;
    }
    try {
      _form.currentState.save();
      await Provider.of<Profile>(context, listen: false)
          .updateSettingsPage(this._username, this._about);
    } catch (error) {
      EasyLoading.showError('Failed with Error');
    } finally {
      EasyLoading.showSuccess('Great Success!');
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      checkIfEmailIsVerified();
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _getValues = Provider.of<Profile>(context).profileDataFromModels;
    _iniValues = {
      'username': _getValues['username'],
      'profilePhoto': _getValues['profilePhoto'],
      'email': _getValues['email'],
      'emailVerify': _getValues['emailVerify'],
      'phone': _getValues['phone'],
      'phoneVerify': _getValues['phoneVerify'],
      'loc_lat': _getValues['loc_lat'],
      'loc_lng': _getValues['loc_lng'],
      'about': _getValues['about'],
    };
    return _mailVerify == null || _iniValues['profilePhoto'] == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text("Settings Page"),
              actions: [
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: _checkStatus == false
                        ? null
                        : () => _updateSettingsPage())
              ],
            ),
            body: FlutterEasyLoading(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        ChangeProfilePhoto(
                          photoUrl: _iniValues['profilePhoto'],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                            ),
                            labelText: "Username",
                            labelStyle: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                          initialValue: _iniValues['username'],
                          onSaved: (newValue) {
                            setState(() {
                              this._username = newValue.trim();
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              this._checkStatus = true;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "hata ver";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _iniValues['email'],
                          enabled: false,
                          decoration: InputDecoration(
                            icon: Icon(Icons.mail_outline),
                            labelText: 'Mail',
                            suffixIcon: _mailVerify == false
                                ? Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                          ),
                        ),
                        if (!_mailVerify) ...[
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Mail adresiniz onaylanmamıştır. Mail adresinizi onaylayabilmek alttaki butona tıklayınız ve göndermiş olduğumuz maildeki linke tıklayınız. ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Center(
                            child: RaisedButton(
                              child: Text("E - Postayı Doğrula"),
                              onPressed: _sendMailVerify,
                            ),
                          ),
                        ],
                        if (_iniValues['phoneVerify'] == true) ...[
                          TextFormField(
                            initialValue: _iniValues['phone'],
                            enabled: false,
                            decoration: InputDecoration(
                              icon: Icon(Icons.phone),
                              labelText: 'Phone',
                              suffixIcon: _mailVerify == false
                                  ? Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    ),
                            ),
                          ),
                        ],
                        if (_iniValues['phoneVerify'] == false) ...[
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            initialValue: _iniValues['phone'],
                            decoration: InputDecoration(
                              icon: Icon(Icons.phone),
                              labelText: "Phone Number",
                              hintText: "+905325320102",
                            ),
                            onChanged: (value) {
                              setState(() {
                                this.phoneNumber = value.trim();
                              });
                            },
                          ),
                          Text("Doğrulamak istediğiniz numarayı giriniz"),
                          FlatButton(
                            onPressed: () {
                              verifyPhone();
                            },
                            child: Text("Doğrulayınız"),
                          ),
                        ],
                        TextFormField(
                          initialValue: _iniValues['about'],
                          minLines: 1,
                          maxLines: 3,
                          maxLength: 250,
                          decoration: InputDecoration(
                            icon: Icon(Icons.accessibility_new),
                            labelText: "About",
                          ),
                          onSaved: (newValue) {
                            setState(() {
                              this._about = newValue.trim();
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              this._checkStatus = true;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _iniValues['loc_lat'] == ""
                            ? LocationInput(_selectPlace, 0.0, 0.0)
                            : LocationInput(_selectPlace, _iniValues['loc_lat'],
                                _iniValues['loc_lng']),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
