import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_workers/Assistants/assistants_methods.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/models/user_ride_request_information.dart';
import 'package:jobs_workers/splash_screen/splash_screen.dart';
import 'package:jobs_workers/widgets/progress_dialog.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({this.userRideRequestDetails});

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

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polylinesPositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineWorkerCurrentPosition;

  String rideRequestStatus = "accepted";

  String durationFromOriginToDestination = "";

  bool isRequestDirectionDetails = false;

  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng, bool darkTheme) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please Wait.....",
            ));

    var directionDetailsInfo =
        await AssistandMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodePolylinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    polylinesPositionCoordinates.clear();

    if (decodePolylinePointsResultList.isNotEmpty) {
      decodePolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        polylinesPositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylinesPositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );
      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    saveAssignedWorkerDetailsToUserRideRequest();
  }

  getDriverLocationUpdatesAtRealTime(){

    LatLng oldLatLng= LatLng(0, 0);
    streamSubscriptionWorkerLivePosition= Geolocator.getPositionStream().listen((Position position) { 
      workerCurrentPosition= position;
      onlineWorkerCurrentPosition= position;

      LatLng latLngLiveWorkerPosition = LatLng(onlineWorkerCurrentPosition!.latitude, onlineWorkerCurrentPosition!.longitude);
      Marker animatingMarker= Marker(
        markerId: MarkerId("AnimatedMarker"),
        position: latLngLiveWorkerPosition,
        icon: iconAnimatedMarker!,
        infoWindow: InfoWindow(title: "This is your position"),
        );

      setState(() {
        CameraPosition cameraPosition= CameraPosition(target: latLngLiveWorkerPosition, zoom: 18);
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere((element) => element.markerId.value=="AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng= latLngLiveWorkerPosition;
      updateDurationTimeAtRealTime();

      Map workerLatLngDataMap= {
        "latitude": onlineWorkerCurrentPosition!.latitude.toString(),
        "longitude":onlineWorkerCurrentPosition!.longitude.toString(),
      };

      FirebaseDatabase.instance.ref().child("All Ride Request").child(widget.userRideRequestDetails!.rideRequestId!).child("workerLocation").set(workerLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime(){
    
  }

  createWorkerIconMarker(){
    if(iconAnimatedMarker==null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/worker.png").then((value){
        iconAnimatedMarker= value;
      });
    }
  }

  saveAssignedWorkerDetailsToUserRideRequest(){
    DatabaseReference databaseReference= FirebaseDatabase.instance.ref().child("All Ride Request").child(widget.userRideRequestDetails!.rideRequestId!);

    Map workerLocationDataMap={
      "latitude": workerCurrentPosition!.latitude.toString(),
      "longitude": workerCurrentPosition!.longitude.toString()
    };

    if(databaseReference.child("workerId") != "waiting"){
      databaseReference.child("workerLocation").set(workerLocationDataMap);

      databaseReference.child("status").set("accepted");
      databaseReference.child("workerId").set(onlineWorkerData.id);
      databaseReference.child("workerName").set(onlineWorkerData.name);
      databaseReference.child("workerPhone").set(onlineWorkerData.phone);
      databaseReference.child("ratings").set(onlineWorkerData.ratings);
      databaseReference.child("car_details").set(onlineWorkerData.car_model.toString()+" "+onlineWorkerData.car_number.toString()+" ("+onlineWorkerData.car_color.toString()+")");

      saveRideRequestIdToDriverHistory();
    }else{
      Fluttertoast.showToast(msg: "This ride is already accepted by another driver. \nRealoding the App");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>SplashScreen()));
    }
  }

  saveRideRequestIdToDriverHistory(){
    DatabaseReference tripHistoryRef = FirebaseDatabase.instance.ref().child("workers").child(firebaseAuth.currentUser!.uid).child("tripHistory");
    tripHistoryRef.child(widget.userRideRequestDetails!.rideRequestId!).set(true);
  }

  @override
  Widget build(BuildContext context) {

    createWorkerIconMarker();
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
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPadding = 350;
              });

              var workerCurrentLatLng = LatLng(workerCurrentPosition!.latitude,
                  workerCurrentPosition!.longitude);
              var userPickUpLatLng =
                  widget.userRideRequestDetails!.originLatLng;

              drawPolyLineFromOriginToDestination(
                  workerCurrentLatLng, userPickUpLatLng!, darkTheme);
              getDriverLocationUpdatesAtRealTime();
            },
          )
        ],
      ),
    );
  }
}
