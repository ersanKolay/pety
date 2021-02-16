import 'package:flutter/material.dart';
import 'package:pety/widgets/category_selector.dart';
import 'package:pety/widgets/favorite_contacts.dart';
import 'package:pety/widgets/recent_charts.dart';

class MessageList extends StatefulWidget {
  static const routeName = '/message-list';
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  MessageList({
    Key key,
    this.menuScreenContext,
    this.onScreenHideButtonPressed,
    this.hideStatus,
  }) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    RecentChats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
