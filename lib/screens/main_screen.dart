import 'package:flutter/material.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/splash_screen/splash_screen.dart';
import 'package:jobs_workers/tabPages/earning_tap.dart';
import 'package:jobs_workers/tabPages/home_tap.dart';
import 'package:jobs_workers/tabPages/profile_tab.dart';
import 'package:jobs_workers/tabPages/ratings_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int selectedIndex=0;

  onItemClicked(int index){
    setState(() {
      selectedIndex= index;
      tabController!.index= selectedIndex;
    });
  } 
  @override

  void initState(){
    super.initState();
    tabController= TabController(length: 4, vsync: this);
  }
  Widget build(BuildContext context) {
    //bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool darkTheme = true;
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),

        ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label:"Home"),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card),label:"Earnings"),
            BottomNavigationBarItem(icon: Icon(Icons.star),label:"Ratings"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label:"Account"),
          ],

          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 14),
          showSelectedLabels: true,
          currentIndex: selectedIndex,
          onTap: onItemClicked,
        ),
    );
  }
}