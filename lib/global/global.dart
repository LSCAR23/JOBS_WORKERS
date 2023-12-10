import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jobs_workers/models/direction_details_info.dart';
import 'package:jobs_workers/models/user_model.dart';
import 'package:jobs_workers/models/worker_data.dart';
final FirebaseAuth firebaseAuth= FirebaseAuth.instance;
User? currentUser;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>?streamSubscriptionWorkerLivePosition;
UserModel? userModelCurrentInfo;
Position? workerCurrentPosition;
WorkerData onlineWorkerData= WorkerData();
String? workerVehicleType="";