


import 'dart:ui';

import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/screens/AboutUsPage.dart';
import 'package:cabdriver/screens/HowItWorksPage.dart';
import 'package:cabdriver/screens/vehicleinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login/login_screen.dart';
import 'MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreen extends StatefulWidget {

  static String id = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_splashScreen.png"),
                    fit: BoxFit.cover
                )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5
              ),
              child: Container(
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Taxi App",
                    style: GoogleFonts.fugazOne(
                        fontSize: 50,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    "For Drivers",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        letterSpacing: 0.7,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  singButton(text: "Login",onPress: ()=>{Navigator.pushNamed(context, LoginScreen.id)},),
                  SizedBox(height: 15),
                  singButton(text: "Sing In",onPress: ()=>{Navigator.pushNamed(context, HowItWorkPage.id)},),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // ignore: deprecated_member_use
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AboutUsPage.id);
                      },
                      child: Text(
                        'About us',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.white
                        ),
                      )
                  ),
                  Text(
                    "-",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HowItWorkPage.id);
                      },
                      child: Text(
                        'How it Work',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.white
                        ),
                      )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class singButton extends StatelessWidget {
  final Function onPress;
  final String text;
  const singButton({
    Key key, this.onPress, this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 60,
        width: 290,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 3),
                  blurRadius: 20
              )
            ]
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20,),
              Center(
                child: Text(
                  text,
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
