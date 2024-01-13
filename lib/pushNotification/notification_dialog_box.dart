import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobs_workers/Assistants/assistants_methods.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/models/user_ride_request_information.dart';
import 'package:provider/provider.dart';

class NotificationDialogBox extends StatefulWidget {
  
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {

    //bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool darkTheme= true;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          margin: EdgeInsets.all(0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/worker.png"
              ),
              SizedBox(height: 10,),

              Text("New Job Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue,
              ),
              ),
              SizedBox(height: 14,),
              Divider(
                height: 2,
                thickness: 2,
                color: Colors.blue,
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset("images/worker.png",
                        width: 30,
                        height: 30,),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userRideRequestDetails!.originAddress!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          )
                          )
                      ],),

                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Image.asset("images/worker.png",
                          width: 30,
                          height: 30,),

                          SizedBox(width: 10,),

                          Expanded(
                            child: Container(
                              child: Text(
                                widget.userRideRequestDetails!.destinationAddress!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          )
                        ],
                      )

                  ],
                ),
                ),

                Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.blue,
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          audioPlayer.pause();
                          audioPlayer.stop();
                          audioPlayer= AssetsAudioPlayer();

                          Navigator.pop(context);
                        }, 
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text(
                          "Cancel".toUpperCase(),
                          style: TextStyle(
                            fontSize:15,
                          ),
                        )
                        ),

                        SizedBox(width: 20,),

                        ElevatedButton(
                          onPressed: (){
                            audioPlayer.pause();
                            audioPlayer.stop();
                            audioPlayer= AssetsAudioPlayer();

                            acceptRideRequest(context);

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ), 
                          child: Text(
                            "Accept".toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                          )
                    ],
                  )
                  ),

            ],
          ),
        ),
    );
  }

  acceptRideRequest(BuildContext context){
    FirebaseDatabase.instance.ref()
    .child("workers")
    .child(firebaseAuth.currentUser!.uid)
    .child("newRideStatus")
    .once()
    .then((snap){
      if(snap.snapshot.value=="idle"){
        FirebaseDatabase.instance.ref().child("workers").child(firebaseAuth.currentUser!.uid).child("newRideStatus").set("accepted");

        AssistandMethods.pauseLiveLocationUpdates();

        //Navigator.push(context, MaterialPageRoute(builder: (c)=> NewTripScreen()));
      }else{
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");
      }
    });   
  }
}