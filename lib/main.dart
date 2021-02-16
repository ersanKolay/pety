import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pety/models/profile.dart';
import 'package:pety/screens/profile_screen.dart';
import 'package:pety/screens/settings_screen.dart';
import 'package:pety/screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/splash_screen.dart';
import 'localization/app_localizations.dart';
import 'localization/constant_localizations.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void didChangeDependencies() {
    getLocale().then((value) {
      setState(() {
        setLocale(value);

        this._locale = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Profile(),
        ),
        
        /*   ChangeNotifierProvider(
            create: (context) => Profile(),
          ), */
      ],
      child: MaterialApp(
        title: 'Flutter Pet Adoption UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFFD6456),
        ),
        supportedLocales: [
          Locale('en', 'US'),
          Locale('tr', 'TR'),
        ],
        locale: _locale,
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        home: SplashScreen(),
        initialRoute: '/',
        routes: {
          TabsScreen.routeName: (context) => TabsScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          LogInScreen.routeName: (context) => LogInScreen(),
          ProfilePage.routeName: (context) => ProfilePage(
                userID: null,
              ),
          SettingsPage.routeName: (context) => SettingsPage(),
        },
      ),
    );
  }
}
