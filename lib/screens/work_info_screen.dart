import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobs_workers/global/global.dart';
import 'package:jobs_workers/splash_screen/splash_screen.dart';

class WorkInfoScreen extends StatefulWidget {
  const WorkInfoScreen({super.key});

  @override
  State<WorkInfoScreen> createState() => _WorkInfoScreenState();
}

class _WorkInfoScreenState extends State<WorkInfoScreen> {
  final carModelTextEditingcontroller = TextEditingController();
  final carNumberTextEditingcontroller = TextEditingController();
  final carColorTextEditingcontroller = TextEditingController();

  List<String> carTypes = ["Car", "CNG", "Bike"];
  String? selectedCarType;
  final _fromKey = GlobalKey<FormState>();

  _submit(){
    if(_fromKey.currentState!.validate()){
      Map driverCarInfoMap={
        "car_model": carModelTextEditingcontroller.text.trim(),
        "car_number": carNumberTextEditingcontroller.text.trim(),
        "car_color": carColorTextEditingcontroller.text.trim(),
      };
      DatabaseReference userRef= FirebaseDatabase.instance.ref().child("workers");
      userRef.child(currentUser!.uid).child("car_details").set(driverCarInfoMap);

      Fluttertoast.showToast(msg: "Car details has been saved. Congratulations");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>SplashScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    //bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool darkTheme = true;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset('images/examp.jpg'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Add Car Details",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                              key: _fromKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: darkTheme
                                                ? Colors.white
                                                : Colors.black),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(50)
                                        ],
                                        decoration: InputDecoration(
                                            hintText: "Car Model",
                                            hintStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                            filled: true,
                                            fillColor: darkTheme
                                                ? Colors.black
                                                : Colors.white,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none)),
                                            prefixIcon: Icon(Icons.person,
                                                color: Colors.blue)),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (text) {
                                          if (text == null || text.isEmpty) {
                                            return 'Name can not be empty';
                                          }
                                          if (text.length < 2 ||
                                              text.length > 49) {
                                            return 'Please enter a valid name';
                                          }
                                        },
                                        onChanged: (text) => setState(() {
                                          carModelTextEditingcontroller.text =
                                              text;
                                        }),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: darkTheme
                                                ? Colors.white
                                                : Colors.black),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(50)
                                        ],
                                        decoration: InputDecoration(
                                            hintText: "Car Number",
                                            hintStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                            filled: true,
                                            fillColor: darkTheme
                                                ? Colors.black
                                                : Colors.white,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none)),
                                            prefixIcon: Icon(Icons.person,
                                                color: Colors.blue)),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (text) {
                                          if (text == null || text.isEmpty) {
                                            return 'Name can not be empty';
                                          }
                                          if (text.length < 2 ||
                                              text.length > 49) {
                                            return 'Please enter a valid name';
                                          }
                                        },
                                        onChanged: (text) => setState(() {
                                          carNumberTextEditingcontroller.text =
                                              text;
                                        }),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: darkTheme
                                                ? Colors.white
                                                : Colors.black),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(50)
                                        ],
                                        decoration: InputDecoration(
                                            hintText: "Car Color",
                                            hintStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                            filled: true,
                                            fillColor: darkTheme
                                                ? Colors.black
                                                : Colors.white,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                borderSide: BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none)),
                                            prefixIcon: Icon(Icons.person,
                                                color: Colors.blue)),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (text) {
                                          if (text == null || text.isEmpty) {
                                            return 'Name can not be empty';
                                          }
                                          if (text.length < 2 ||
                                              text.length > 49) {
                                            return 'Please enter a valid name';
                                          }
                                        },
                                        onChanged: (text) => setState(() {
                                          carColorTextEditingcontroller.text =
                                              text;
                                        }),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          hintText: 'Please choose a car type',
                                          prefixIcon: Icon(
                                            Icons.car_crash,
                                            color: Colors.blue,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ))),
                                      items: carTypes.map((car) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            car,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          value: car,
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCarType = newValue.toString();
                                        });
                                      }),
                                      SizedBox(height: 20,),

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          onPrimary: Colors.blue,
                                          elevation:
                                              5.0, // Change this line for shadow depth
                                          shadowColor: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          side: BorderSide(color: Colors.blue),
                                          minimumSize:
                                              Size(double.infinity, 50)),
                                      onPressed: () {
                                        _submit();
                                      },
                                      child: Text('Register',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ))),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Have an account?',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          onPrimary: darkTheme
                                              ? Colors.grey
                                              : Colors.black,
                                          elevation:
                                              5.0, // Change this line for shadow depth
                                          shadowColor: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          side: BorderSide(
                                              color: darkTheme
                                                  ? Colors.grey
                                                  : Colors.black,
                                              width: 2.0),
                                          minimumSize:
                                              Size(double.infinity, 50)),
                                      onPressed: () {},
                                      child: Text('Sign In',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ))),
                                  /*GestureDetector(
                                      onTap: () {},
                                      child: Text('Sign In',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.blue,
                                          )),
                                    )*/
                                ],
                              )),
                        ]))
              ],
            )
          ],
        ),
      ),
    );
  }
}
