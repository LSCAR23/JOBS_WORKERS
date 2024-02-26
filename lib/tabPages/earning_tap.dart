import 'package:flutter/material.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/infoHandler/app_info.dart';
import 'package:jobs_workers/screens/trips_history_screen.dart';
import 'package:provider/provider.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({super.key});

  @override
  State<EarningsTabPage> createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  Widget build(BuildContext context) {

    //bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool darkTheme = true;
    return Container(
      color: darkTheme? Colors.amberAccent: Colors.lightBlue,
      child: Column(
        children: [
          Container(
            color: darkTheme? Colors.black:Colors.lightBlue,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  Text(
                    "Your Earnings",
                    style: TextStyle(
                      color: darkTheme? Colors.amber.shade400: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 18,),

                  Text(
                    "C "+ Provider.of<AppInfo>(context,listen: false).workerTotalEarnings,
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),

          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> TripsHistoryScreen()));
            }, 
            style: ElevatedButton.styleFrom(
              primary: Colors.white54
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    "images.worker.png",
                    scale: 2,
                  ),
                  Expanded(
                    child: Text(
                      Provider.of<AppInfo>(context,listen: false).allTripHistoryInformationList.length.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ) 
                    )
                ],
              ), 
              ),
            )
        ],
      ),
    );
  }
}