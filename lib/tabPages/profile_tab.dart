import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/splash_screen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("workers");

  Future<void> showWorkerNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text= name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Update"),
              content: SingleChildScrollView(
                child: Column(children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ]),
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                }, 
                child: Text("Cancel",style: TextStyle(color:Colors.red),)
                ),

                TextButton(
                  onPressed: (){
                    userRef.child(firebaseAuth.currentUser!.uid).update({
                      "name":nameTextEditingController.text.trim(),
                    }).then((value){
                      nameTextEditingController.clear();
                      Fluttertoast.showToast(msg: "Updated Succesfully. \n Reload the app to see the changes.");

                    }).catchError((errorMessage){
                      Fluttertoast.showToast(msg:"Error Occurred. \n $errorMessage");
                    });
                    Navigator.pop(context);
                }, 
                child: Text("OK",style: TextStyle(color:Colors.black),)
                ),
              ]);
        });
  }

  Future<void> showWorkerPhoneDialogAlert(BuildContext context, String phone) {
    phoneTextEditingController.text= phone;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Update"),
              content: SingleChildScrollView(
                child: Column(children: [
                  TextFormField(
                    controller: phoneTextEditingController,
                  )
                ]),
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                }, 
                child: Text("Cancel",style: TextStyle(color:Colors.red),)
                ),

                TextButton(
                  onPressed: (){
                    userRef.child(firebaseAuth.currentUser!.uid).update({
                      "phone":phoneTextEditingController.text.trim(),
                    }).then((value){
                      phoneTextEditingController.clear();
                      Fluttertoast.showToast(msg: "Updated Succesfully. \n Reload the app to see the changes.");

                    }).catchError((errorMessage){
                      Fluttertoast.showToast(msg:"Error Occurred. \n $errorMessage");
                    });
                    Navigator.pop(context);
                }, 
                child: Text("OK",style: TextStyle(color:Colors.black),)
                ),
              ]);
        });
  }

 Future<void> showWorkerAddressDialogAlert(BuildContext context, String address) {
    addressTextEditingController.text= address;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Update"),
              content: SingleChildScrollView(
                child: Column(children: [
                  TextFormField(
                    controller: addressTextEditingController,
                  )
                ]),
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                }, 
                child: Text("Cancel",style: TextStyle(color:Colors.red),)
                ),

                TextButton(
                  onPressed: (){
                    userRef.child(firebaseAuth.currentUser!.uid).update({
                      "address":addressTextEditingController.text.trim(),
                    }).then((value){
                      addressTextEditingController.clear();
                      Fluttertoast.showToast(msg: "Updated Succesfully. \n Reload the app to see the changes.");

                    }).catchError((errorMessage){
                      Fluttertoast.showToast(msg:"Error Occurred. \n $errorMessage");
                    });
                    Navigator.pop(context);
                }, 
                child: Text("OK",style: TextStyle(color:Colors.black),)
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {

     bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    //bool darkTheme = true;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: darkTheme? Colors.amber.shade400: Colors.black,
            ),
          ),
          title: Text(
            "Profile Screen",
            style: TextStyle(color: darkTheme? Colors.amber.shade400: Colors.black,fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: darkTheme? Colors.amber.shade400: Colors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person,color:darkTheme?Colors.black:Colors.white),
                    ),

                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineWorkerData.name!}",
                          style: TextStyle(
                            color: darkTheme? Colors.amber.shade400: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        IconButton(
                          onPressed: (){
                            showWorkerNameDialogAlert(context,onlineWorkerData.name!);
                          }, 
                          icon: Icon(Icons.edit,color: darkTheme? Colors.amber.shade400:Colors.blue,)
                          ),
                      ],
                    ),

                    Divider(thickness: 1,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineWorkerData.phone!}",
                          style: TextStyle(
                            color: darkTheme? Colors.amber.shade400: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        IconButton(
                          onPressed: (){
                            showWorkerPhoneDialogAlert(context,onlineWorkerData.phone!);
                          }, 
                          icon: Icon(Icons.edit,color: darkTheme? Colors.amber.shade400:Colors.blue,)
                          ),
                      ],
                    ),

                    Divider(thickness: 1,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineWorkerData.address!}",
                          style: TextStyle(
                            color: darkTheme? Colors.amber.shade400: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        IconButton(
                          onPressed: (){
                            showWorkerAddressDialogAlert(context,onlineWorkerData.address!);
                          }, 
                          icon: Icon(Icons.edit,color: darkTheme? Colors.amber.shade400:Colors.blue,)
                          ),
                      ],
                    ),

                    Divider(thickness: 1,),

                    Text(
                        "${onlineWorkerData.email!}",
                        style: TextStyle(
                          color: darkTheme? Colors.amber.shade400: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineWorkerData.car_model!} \n${onlineWorkerData.car_color!} (${onlineWorkerData.car_number!})",
                          style: TextStyle(
                            color: darkTheme? Colors.amber.shade400: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        Image.asset(
                          onlineWorkerData.car_type=="Car" ? "images/worker.png":"images/worker.png",
                          scale: 2,
                        ), 
                      ]
                    ),

                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: (){
                        firebaseAuth.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>SplashScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ), 
                    child:Text("Log Out"),
                  )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}