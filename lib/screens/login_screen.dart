import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pety/models/profile.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/language.dart';
import '../localization/constant_localizations.dart';
import '../screens/signup_screen.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  LogInScreenState createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<void> _showErrorDialog(String message) {
    return Fluttertoast.showToast(
        msg: getTranslated(context, message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  Future<void> _login(BuildContext context) async {
    String email = emailController.value.text.toString().trim();
    String password = passController.value.text.toString().trim();
    if (EmailValidator.validate(email) == false) {
      _showErrorDialog("plsentmail");
    } else if (!(passController.value.text.trim().toString().length > 5)) {
      _showErrorDialog("plsentpass");
    } else {
      Provider.of<Profile>(context, listen: false)
          .login(email, password, context );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  Future _changeLang(Language language) async {
    Locale _temp = await setLocale(language.langCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    print("Login page");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: ListView(
            shrinkWrap: true,
            reverse: false,
            children: <Widget>[
              new SizedBox(
                height: 20.0,
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: Text(getTranslated(context, "LOGIN"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20.0, bottom: 10.0),
                        child: DropdownButton(
                          underline: SizedBox(),
                          items: Language.langList()
                              .map<DropdownMenuItem<Language>>(
                                  (e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(e.name + ' '),
                                            Text(e.flag),
                                          ],
                                        ),
                                      ))
                              .toList(),
                          onChanged: (Language language) {
                            _changeLang(language);
                          },
                          icon: Icon(
                            Icons.language,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/jump.gif",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Form(
                              key: _formKey,
                              autovalidate: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      controller: emailController,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        labelText:
                                            getTranslated(context, "email"),
                                        prefixIcon: Padding(
                                            padding:
                                                EdgeInsets.only(right: 7.0),
                                            child: Image.asset(
                                              "assets/images/email_icon.png",
                                              height: 25.0,
                                              width: 25.0,
                                              fit: BoxFit.scaleDown,
                                            )),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 5.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        autofocus: false,
                                        controller: passController,
                                        decoration: InputDecoration(
                                            labelText: getTranslated(
                                                context, "password"),
                                            prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 7.0),
                                                child: Image.asset(
                                                  "assets/images/password_icon.png",
                                                  height: 25.0,
                                                  width: 25.0,
                                                  fit: BoxFit.scaleDown,
                                                ))),
                                        keyboardType: TextInputType.text,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0, top: 25, bottom: 10.0),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: () => _login(context),
                                      child: Text(
                                        getTranslated(context, "Login"),
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      color: Color(0xFF54C5F8),
                                      textColor: Colors.white,
                                      elevation: 5.0,
                                      padding: EdgeInsets.only(
                                          left: 80.0,
                                          right: 80.0,
                                          top: 10.0,
                                          bottom: 10.0),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              SignUpScreen.routeName);
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child: Text(
                                              getTranslated(context, "dontacc"),
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 15.0),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
