import 'dart:async';

import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/datamodels/driver.dart';
import 'package:cabdriver/datamodels/tripdetails.dart';
import 'package:cabdriver/globalvariabels.dart';
import 'package:cabdriver/helpers/helpermethods.dart';
import 'package:cabdriver/helpers/pushnotificationservice.dart';
import 'package:cabdriver/screens/ContactIsPage.dart';
import 'package:cabdriver/screens/HowItWorksPage.dart';
import 'package:cabdriver/screens/MyTripsPage.dart';
import 'package:cabdriver/widgets/BrandDivier.dart';
import 'package:cabdriver/widgets/ConfirmSheet.dart';
import 'package:cabdriver/widgets/NotificationDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Taxi_App_Color.dart';
import 'SplashScreen.dart';

class MainPage extends StatefulWidget {

  static String id = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DatabaseReference tripRequestRef;

  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);


  bool isOnline = false;
  Color onlineColor = Color(0xffff0066);
  String onlineText = "OFFLINE";

  final GoogleSignIn _googleSignIn = GoogleSignIn();


  void getCurrentPosition() async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));

  }

  void initNotification() async {

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    HelperMethods.getHistoryInfo(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotification();
    HelperMethods.getCurrentUserInfo();
    loadMapStyles();
  }

  String _darkMapStyle;
  String _lightMapStyle;

  Future loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('mapStyle/DarkMode.json');
    _lightMapStyle = await rootBundle.loadString('mapStyle/LightMode.json');
  }

  // switch Dark / Light Mode of Google Map
  Future setMapStyle(ThemeProvider themeProvider) async {
    final controller = await _controller.future;
    if (themeProvider.checkDarkMode == true)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    setMapStyle(themeProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 280,
        color: TaxiAppColor.colorWhiteBackground,
        child: Drawer(
          child: Container(
            color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : Colors.white,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : Colors.white,
                  height: 160,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : Colors.white,),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl:
                            currentFirebaseUser.currentUser.photoURL,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                                  backgroundColor: TaxiAppColor.colorDarkLight,
                                ),
                            height: 60,
                            width: 60,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 160,
                              child: Text(
                                currentFirebaseUser.currentUser.displayName,
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'I\'m a Driver',
                              style: GoogleFonts.lato(
                                  color: TaxiAppColor.colorGrey
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: SvgPicture.asset(car,height: 28,width: 28,color: TaxiAppColor.colorGrey,),
                  title: Text(
                    'My Trips',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                        fontSize: 18
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, MyTripsPage.id);
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(help,height: 25,width: 25,color: TaxiAppColor.colorGrey,),
                  title: Text(
                    'How it Work',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                        fontSize: 18
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, HowItWorkPage.id);
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(contactUs,height: 28,width: 28,color: TaxiAppColor.colorGrey,),
                  title: Text(
                    'Contact us',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                        fontSize: 18
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, ContactUsPage.id);
                  },
                ),
                SizedBox(height: 40,),
                ListTile(
                  leading: SvgPicture.asset(signOutIcon,height: 28,width: 28, color: TaxiAppColor.colorPink),
                  title: Text(
                    'Sign Out',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: TaxiAppColor.colorPink,
                        fontSize: 18
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0.0,
                          child: Container(
                            margin: EdgeInsets.all(0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [

                                    Text('Sign Out',
                                      style: GoogleFonts.lato(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    BrandDivider(),

                                    SizedBox(height: 15,),

                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'are you sure you want signOut!',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    SizedBox(height: 30,),

                                    GestureDetector(
                                      onTap: () {

                                        signOut();
                                        signOutGoogle();
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, SplashScreen.id, (route) => false);

                                      },
                                      child: Container(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 2,
                                              color: TaxiAppColor.colorPink
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                signOutIcon, height: 20,width: 20,
                                                color: TaxiAppColor.colorPink
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                              "Sign Out",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: TaxiAppColor.colorPink
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),


                                    SizedBox(height: 10,),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: googlePlex,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;

              getCurrentPosition();
            },
          ),

          ///Switch Theme Mode Button
          Positioned(
            top: 45,
            right: 20,
            child: GestureDetector(
              onTap: () async {
                // switch Theme dark / light
                setState(() {
                  themeProvider.swapTheme();
                });

              },
              child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26.withOpacity(0.1),
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ))
                      ]),
                  child: SvgPicture.asset(
                    themeProvider.checkDarkMode == true
                        ? light
                        : dark,
                    color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                  )
              ),
            ),
          ),

          /// MenuButton
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                  scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26.withOpacity(0.1),
                          blurRadius: 5.0,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          ))
                    ]),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                         child: CachedNetworkImage(
                          imageUrl:
                          currentFirebaseUser.currentUser.photoURL,
                          placeholder: (context, url) =>
                            CircularProgressIndicator(
                              backgroundColor: TaxiAppColor.colorDarkLight,
                            ),
                        height: 60,
                        width: 60,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    )
                      ),
              ),
            ),
          ),

          /// OnlineButton
          Positioned(
            bottom: 40,
            right: 20,
            left: 20,
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                        title: (!isOnline) ? 'GO ONLINE' : 'GO OFFLINE',
                        subtitle: (!isOnline)
                            ? 'You are about to become available to receive trip requests'
                            : 'you will stop receiving new trip requests',
                        onPressed: () {
                          if (!isOnline) {
                            GoOnline();
                            getLocationUpdates();
                            Navigator.pop(context);

                            setState(() {
                              onlineColor = TaxiAppColor.colorGreen;
                              onlineText = 'ONLINE';
                              isOnline = true;
                            });

                          } else {
                            GoOffline();
                            Navigator.pop(context);
                            setState(() {
                              onlineColor = TaxiAppColor.colorPink;
                              onlineText = 'OFFLINE';
                              isOnline = false;
                            });
                          }
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: onlineColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: onlineColor.withOpacity(0.3),
                              offset: Offset(0,10),
                              blurRadius: 20
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(car, color: Colors.white,),
                        SizedBox(width: 20,),
                        Text(
                          onlineText,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void GoOnline(){
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(currentFirebaseUser.currentUser.uid, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance.reference().child('driver_users/${currentFirebaseUser.currentUser.uid}/newtrip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {

    });

  }

  void GoOffline (){

    Geofire.removeLocation(currentFirebaseUser.currentUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;

  }

  void getLocationUpdates(){

    homeTabPositionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position position) {
      currentPosition = position;

      if(isOnline){
        Geofire.setLocation(currentFirebaseUser.currentUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));

    });

  }

  Future<void> signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Signed Out");
  }
}
