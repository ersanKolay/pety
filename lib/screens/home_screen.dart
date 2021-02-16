import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pety/models/profile.dart';
import 'package:pety/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/constant_localizations.dart';
import '../models/pet_model.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const HomeScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userID;

  Widget _buildPetCategory(bool isSelected, String category) {
    return GestureDetector(
      onTap: () => print('Selected $category'),
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: 80.0,
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).primaryColor : Color(0xFFF8F2F7),
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(
                  width: 8.0,
                  color: Color(0xFFFED8D3),
                )
              : null,
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    Provider.of<Profile>(context).signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<Profile>(context,listen: false).user;
    _user == null ? _userID = null : _userID = _user.uid;
    print(_user.uid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.5,
        centerTitle: true,
        title: Text(
          'Pety',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          _userID != null
              ? IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _signOut(context);
                    pushNewScreen(context, screen: LogInScreen());
                  })
              : IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.check),
                  onPressed: () {})
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 5),
                width: 80,
                height: 80,
                color: Colors.black,
              ),
            ),
            height: 100,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pets.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(pets[index].imageUrl),
                            fit: BoxFit.cover)),
                    height: MediaQuery.of(context).size.width * (9 / 16),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    bottom: 15,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pets[index].name,
                          style: GoogleFonts.lobster(
                              color: Colors.white, fontSize: 24),
                        ),
                        Text(
                          '${pets[index].city} - ${pets[index].sex != "female" ? getTranslated(context, "male") : getTranslated(context, "female")} - ${pets[index].age}',
                          style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w200),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
