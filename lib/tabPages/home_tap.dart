import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_workers/Assistants/assistants_methods.dart';
import 'package:jobs_workers/global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isWorkerActive = false;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateWorkerPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    workerCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(
        workerCurrentPosition!.latitude, workerCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress =
        await AssistandMethods.searchAddressForGeographicCoordinates(
            workerCurrentPosition!, context);
    print("This is our address = " + humanReadableAddress);
  }

  readCurrentDriverInformation() async {
    currentUser = firebaseAuth.currentUser;
    FirebaseDatabase.instance
        .ref()
        .child("workers")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineWorkerData.id = (snap.snapshot.value as Map)["id"];
        onlineWorkerData.name = (snap.snapshot.value as Map)["name"];
        onlineWorkerData.phone = (snap.snapshot.value as Map)["phone"];
        onlineWorkerData.email = (snap.snapshot.value as Map)["email"];
        onlineWorkerData.address = (snap.snapshot.value as Map)["address"];
        onlineWorkerData.car_model =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineWorkerData.car_number =
            (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineWorkerData.car_color =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineWorkerData.car_type =
            (snap.snapshot.value as Map)["car_details"]["type"];
        workerVehicleType = (snap.snapshot.value as Map)["car_details"]["type"];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 40),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locateWorkerPosition();
          },
        ),
        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),
        Positioned(
            top: statusText != "Now Online"
                ? MediaQuery.of(context).size.height * 0.45
                : 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (isWorkerActive != true) {
                        workerIsOnlineNow();
                        updateWorkersLocationAtRealTime();

                        setState(() {
                          statusText = "Now Online";
                          isWorkerActive = true;
                          buttonColor = Colors.transparent;
                        });
                      } else {
                        workerIsOfflineNow();
                        setState(() {
                          statusText = "Now Offline";
                          isWorkerActive = false;
                          buttonColor = Colors.grey;
                        });
                        Fluttertoast.showToast(msg: "You are Offline now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: buttonColor,
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        )),
                    child: statusText != "Now Online"
                        ? Text(
                            statusText,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : Icon(
                            Icons.phonelink_ring,
                            color: Colors.white,
                            size: 26,
                          ))
              ],
            ))
      ],
    );
  }

  workerIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    workerCurrentPosition = pos;

    Geofire.initialize("activeWorkers");
    Geofire.setLocation(currentUser!.uid, workerCurrentPosition!.latitude,
        workerCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("workers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateWorkersLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isWorkerActive == true) {
        Geofire.setLocation(currentUser!.uid, workerCurrentPosition!.latitude,
            workerCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
          workerCurrentPosition!.latitude, workerCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  workerIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("workers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    /*Future.delayed(Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeListMethod("SystemNavigator.pop");
    });*/
  }
}
