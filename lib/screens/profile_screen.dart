import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pety/models/profile.dart';
import 'package:pety/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  final String userID;

  const ProfilePage({
    Key key,
    this.menuScreenContext,
    this.onScreenHideButtonPressed,
    this.hideStatus = false,
    this.userID,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<Profile>(context, listen: false).user;
    return FutureBuilder(
      future: Provider.of<Profile>(context, listen: false)
          .getProfileData(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Consumer<Profile>(
            builder: (_, profileData, child) => Stack(
                      children: [
                        Container(
                          color: Colors.pink.withOpacity(0.1),
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 65),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(profileData
                                      .profileDataFromModels['profilePhoto']),
                                  radius: 60,
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profileData.profileDataFromModels[
                                              'username'],
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 25),
                                          overflow: TextOverflow.clip,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            if (profileData
                                                        .profileDataFromModels[
                                                    'emailVerify'] ==
                                                true) ...[
                                              Icon(
                                                Icons.mail,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                            if (profileData
                                                        .profileDataFromModels[
                                                    'phoneVerify'] ==
                                                true) ...[
                                              Icon(
                                                Icons.phone,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                widget.userID == _user.uid
                                    ? IconButton(
                                        onPressed: () {
                                          pushNewScreenWithRouteSettings(
                                              context,
                                              settings: RouteSettings(
                                                  name: '/settings',
                                                  arguments: widget.userID),
                                              screen: SettingsPage(),
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation.fade);
                                        },
                                        icon: Icon(
                                          Icons.settings,
                                          size: 30,
                                        ),
                                      )
                                    : SizedBox(
                                        width: 30,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
          );
        }
      },
    );
  }
}
