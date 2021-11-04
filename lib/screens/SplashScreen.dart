


import 'dart:ui';

import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/screens/AboutUsPage.dart';
import 'package:cabdriver/screens/HowItWorksPage.dart';
import 'package:cabdriver/screens/vehicleinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  GestureDetector(
                    onTap: () async{
                      signInWithGoogle();
                    },
                    child: Container(
                      height: 60,
                      width: 290,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0,3),
                                blurRadius: 20
                            )
                          ]
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              google,
                              height: 30,
                              width: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Sign In with Google",
                              style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // ignore: deprecated_member_use
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: (){
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
                      onPressed: (){

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

  // Google SignIn
  Future<UserCredential> signInWithGoogle() async {


    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      //addGoogleUserToDb(user);

      print('signInWithGoogle succeeded: $user');

      return authResult;
    }

    return null;
  }

  Future<void> addGoogleUserToDb(User currentuser) async {

    await Firebase.initializeApp();

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("driver_users/${currentuser.uid}");
    Future<DataSnapshot> checkUser = FirebaseDatabase.instance.reference().child("driver_users/${currentuser.uid}").once();

    Map userMap = {
      'fullName': "grich",
      'email': "test",
      'photoProfile': "test",
      'driver_id': "test",
    };

    // checkUser.then((snapShot){
    //   if(snapShot.value == null){
    //     databaseReference.set(userMap);
    //     // after sign in with google go to HomePage
    //   }else{
    //     //Take the user to the Home Page if is Already in Database
    //     Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    //   }
    // }
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);




  }
}
