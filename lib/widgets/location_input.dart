import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pety/helpers/location_helper.dart';
import 'package:pety/models/profile.dart';
import 'package:pety/screens/map_screen.dart';
import 'package:provider/provider.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  final double latitude;
  final double longitude;
  LocationInput(this.onSelectPlace, this.latitude, this.longitude);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  void initState() {
    // ignore: unrelated_type_equality_checks
    if (widget.latitude != "" || widget.longitude != "") {
      _showPreview(widget.latitude, widget.longitude);
    }
    super.initState();
  }

  String _previewImageUrl;
  void _showPreview(double lat, double lng) {
    print("map sorgunlandı");
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    Provider.of<Profile>(context, listen: false).dbLocationUpdate(lat, lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {}
  }

  Future<void> _selectOnMap(double lat, double lng) async {
    if (lat != 0.0 && lng != 0.0) {
      final selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          fullscreenDialog: false,
          builder: (context) => MapScreen(
            latitude: lat,
            longitude: lng,
            isSelecting: true,
          ),
        ),
      );
      if (selectedLocation == null) {
        return;
      }
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);

      widget.onSelectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    } else {
      final selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          fullscreenDialog: false,
          builder: (context) => MapScreen(
            isSelecting: true,
          ),
        ),
      );
      if (selectedLocation == null) {
        return;
      }
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);

      widget.onSelectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text(
                'Current Location',
              ),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: () => _selectOnMap(widget.latitude, widget.longitude),
              icon: Icon(Icons.map),
              label: Text(
                'Select on Map',
              ),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
