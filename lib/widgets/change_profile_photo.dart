import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pety/models/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfilePhoto extends StatefulWidget {
  final String photoUrl;
  ChangeProfilePhoto({Key key, @required this.photoUrl}) : super(key: key);

  @override
  _ChangeProfilePhotoState createState() => _ChangeProfilePhotoState();
}

class _ChangeProfilePhotoState extends State<ChangeProfilePhoto> {
  File _imageFile;
  final _picker = ImagePicker();
  Future<void> _takePhoto(BuildContext context, ImageSource source) async {
    final photo = await _picker.getImage(
      source: source,
    );

    if (photo != null) {
      final cropped = await ImageCropper.cropImage(
        sourcePath: photo.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        maxHeight: 500,
        maxWidth: 500,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            lockAspectRatio: true,
            toolbarColor: Colors.deepOrange,
            statusBarColor: Colors.deepOrange.shade900),
      );
      this.setState(() {
        _imageFile = File(cropped.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final ref = FirebaseStorage.instance
          .ref()
          .child("profile")
          .child(prefs.getString('id') + ".jpg");
      await ref.putFile(_imageFile).onComplete;
      final _url = await ref.getDownloadURL();
      await Provider.of<Profile>(context, listen: false).ppUpdate(_url);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.photoUrl),
          radius: 60,
        ),
        FlatButton(
            child: Text("Change Profile Photo"),
            onPressed: () {
              showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.white,
                enableDrag: true,
                useRootNavigator: true,
                builder: (context, scrollController) => Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('Gallery'),
                        leading: Icon(Icons.camera_roll),
                        onTap: () => _takePhoto(context, ImageSource.gallery),
                      ),
                      ListTile(
                        title: Text('Camera'),
                        leading: Icon(Icons.photo_camera),
                        onTap: () => _takePhoto(context, ImageSource.camera),
                      ),
                      ListTile(
                        title: Text('Cancel'),
                        leading: Icon(Icons.cancel),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                /* */
              );
            }),
      ],
    );
  }
}
