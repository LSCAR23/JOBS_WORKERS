import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/models/user_ride_request_information.dart';

class NewTripScreen extends StatefulWidget {

  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({
    this.userRideRequestDetails
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {

   GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> setOfMarkers= Set<Marker>();
  Set<Circle> setOfCircle= Set<Circle>();
  Set<Polyline> setOfPolyline= Set<Polyline>();
  List<LatLng> PolylinesPositionCoordinates = [];
  PolylinePoints polylinePoints= PolylinePoints();

  double mapPadding=0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator= Geolocator();
  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = "accepted";

  String durationFromOriginToDestination="";

  bool isRequestDirectionDetails= false;



  @override
  Widget build(BuildContext context) {

    //bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool darkTheme = true;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController= controller;

              setState(() {
                mapPadding=350;
              });

              var workerCurrentLatLng= LatLng(workerCurrentPosition!.latitude, workerCurrentPosition!.longitude);
              var userPickUpLatLng= widget.userRideRequestDetails!.originLatLng;

              drawPolyLineFromOriginToDestination(workerCurrentLatLng,userPickUpLatLng,darkTheme);
              getDriverLocationUpdatesAtRealTime();
            },
          )
        ],
      ),
    );
  }
}