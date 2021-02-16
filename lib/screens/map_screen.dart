import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pety/models/place_location.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initalLocation;
  final double latitude;
  final double longitude;
  final bool isSelecting;

  MapScreen(
      {this.initalLocation =
          const PlaceLocation(latitude: 37.0, longitude: -122.0),
      this.isSelecting = false,
      this.latitude,
      this.longitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // PermissionStatus permission = await LocationPermissions().requestPermissions();
  LatLng _pickedLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Map"),
        actions: [
          if (widget.isSelecting)
            IconButton(
                icon: Icon(Icons.check),
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      })
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.latitude != 0.0
                  ? widget.latitude
                  : widget.initalLocation.latitude,
              widget.longitude != 0.0
                  ? widget.longitude
                  : widget.initalLocation.longitude,
            ),
            zoom: 16,
          ),
          onTap: widget.isSelecting ? _selectLocation : null,
          markers: (_pickedLocation == null && widget.isSelecting)
              ? null
              : {
                  Marker(
                    markerId: MarkerId('m1'),
                    position: _pickedLocation ??
                        LatLng(widget.initalLocation.latitude,
                            widget.initalLocation.longitude),
                  )
                },
        ),
      ),
    );
  }
}
