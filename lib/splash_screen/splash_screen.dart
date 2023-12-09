import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobs_workers/Assistants/assistants_methods.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/screens/login_screen.dart';
import 'package:jobs_workers/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async { 
      if(await firebaseAuth.currentUser!=null){
        firebaseAuth.currentUser!=null ? AssistandMethods.readCurrentOnlineUserInfo(): null;
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
      }
    });
  }


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('JOBS WORKERS',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold
        ),
        ),
      )
    );
  }
}