import 'dart:async';
import 'dart:io';

import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/datamodels/driver.dart';
import 'package:cabdriver/datamodels/tripdetails.dart';
import 'package:cabdriver/globalvariabels.dart';
import 'package:cabdriver/helpers/helpermethods.dart';
import 'package:cabdriver/helpers/mapkithelper.dart';
import 'package:cabdriver/widgets/BrandDivier.dart';
import 'package:cabdriver/widgets/CollectPaymentDialog.dart';
import 'package:cabdriver/widgets/ProgressDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Taxi_App_Color.dart';

class NewTripPage extends StatefulWidget {

  static String id = "NewTripPage";

  final TripDetails tripDetails;
  NewTripPage({this.tripDetails});
  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {

  GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();
  double mapPaddingBottom = 0;

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polyLines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);

  BitmapDescriptor movingMarkerIcon;

  Position myPosition;

  String status = 'accepted';

  String durationString = '';

  bool isRequestingDirection = false;

  String buttonTitle = 'ARRIVED';

  Color buttonColor = TaxiAppColor.colorDarkLight;

  Timer timer;

  int durationCounter = 0;

  void createMarker(){
    if(movingMarkerIcon == null){

      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, (Platform.isIOS)
          ? 'images/car_ios.png'
          : 'images/car_android.png'
      ).then((icon){
        movingMarkerIcon = icon;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverInfo();
    acceptTrip();
    loadMapStyles();
  }

  getDriverInfo() async{

    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('driver_users/${currentFirebaseUser.currentUser.uid}');
    driverRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        currentDriverInfo = Driver.fromSnapshot(snapshot);
        print("NewTrip Driver Car Info : ${currentDriverInfo.carColor}");
      }

    });
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

    createMarker();

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    setMapStyle(themeProvider);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            trafficEnabled: true,
            mapType: MapType.normal,
            circles: _circles,
            markers: _markers,
            polylines: _polyLines,
            initialCameraPosition: googlePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              rideMapController = controller;

              setState(() {
                mapPaddingBottom = 260;
              });

              var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickupLatLng = widget.tripDetails.pickup;
              await getDirection(currentLatLng, pickupLatLng);

              getLocationUpdates();

            },
          ),


          Positioned(
            left: 0,
            right: 0,
              bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    )
                  ],
              ),
              height: 370,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: TaxiAppColor.colorGreen,
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(width: 6,),
                        Text(
                          "Arrived in -   ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          durationString,
                          style: GoogleFonts.lato(
                              fontSize: 18,
                            color: TaxiAppColor.colorGrey
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    BrandDivider(),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl: widget.tripDetails.riderPhoto,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                      backgroundColor: TaxiAppColor.colorDarkLight,
                                    ),
                                height: 50,
                                width: 50,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              widget.tripDetails.riderName,
                              style: GoogleFonts.lato(
                                  fontSize: 22,
                                fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),
                       GestureDetector(
                         onTap: () async{

                           // launch driver phone number
                           var url = "tel:${widget.tripDetails.riderPhone}";
                           if (await canLaunch(url)) {
                             await launch(url);
                           } else {
                             throw 'Could not launch $url';
                           }
                         },
                         child: SvgPicture.asset(
                           call,
                           height: 25,
                           width: 25,
                           color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorGreen : TaxiAppColor.colorDark,
                         ),
                       )
                      ],
                    ),

                    SizedBox(height:  25,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Row(
                            children: [
                              SvgPicture.asset(pickIcon, color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(
                                  widget.tripDetails.pickupAddress,
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: TaxiAppColor.colorGrey
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.2),
                          child: Column(
                            children: [
                              Container(
                                height: 4,
                                width: 2,
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                                ),

                              ),
                              SizedBox(height: 3,),
                              Container(
                                height: 4,
                                width: 2,
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                                ),

                              ),
                              SizedBox(height: 3,),
                              Container(
                                height: 4,
                                width: 2,
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                                ),

                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              SvgPicture.asset(destIcon, height: 24, width: 24,color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(
                                  widget.tripDetails.destinationAddress,
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: TaxiAppColor.colorGrey
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            person,
                            height: 25,
                            width: 25,
                            color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            widget.tripDetails.personNumber,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: TaxiAppColor.colorGrey
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 30,),

                    Expanded(
                      child: GestureDetector(
                        onTap: () async{

                          if(status == 'accepted'){

                            status = 'arrived';
                            rideRef.child('status').set(('arrived'));

                            setState(() {
                              buttonTitle = 'START TRIP';
                              buttonColor = TaxiAppColor.colorDarkLight;
                            });

                            HelperMethods.showProgressDialog(context);

                            await getDirection(widget.tripDetails.pickup, widget.tripDetails.destination);

                            Navigator.pop(context);
                          }
                          else if(status == 'arrived'){
                            status = 'ontrip';
                            rideRef.child('status').set('ontrip');

                            setState(() {
                              buttonTitle = 'END TRIP';
                              buttonColor = TaxiAppColor.colorPink;
                            });

                            startTimer();
                          }
                          else if(status == 'ontrip'){
                            endTrip();
                          }

                        },
                        child: Container(
                          height: 65,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: buttonColor
                          ),
                          child: Center(
                            child: Text(
                              buttonTitle,
                              style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )

        ],

      ),
    );
  }

  void acceptTrip(){

    HelperMethods.getCurrentUserInfo();

    String rideID = widget.tripDetails.rideID;
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$rideID');

    rideRef.child('status').set('accepted');
    rideRef.child('driver_name').set(currentFirebaseUser.currentUser.displayName);
    rideRef.child('car_details').set('${currentDriverInfo.carColor} - ${currentDriverInfo.carModel}');
    rideRef.child('driver_phone').set(currentDriverInfo.phoneNumber);
    rideRef.child('driver_photoProfile').set(currentFirebaseUser.currentUser.photoURL);
    rideRef.child('driver_id').set(currentFirebaseUser.currentUser.uid);

    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };

    rideRef.child('driver_location').set(locationMap);

    DatabaseReference historyRef = FirebaseDatabase.instance.reference().child('driver_users/${currentFirebaseUser.currentUser.uid}/history/$rideID');
    historyRef.set(true);

  }

  void getLocationUpdates(){

    LatLng oldPosition = LatLng(0,0);

    ridePositionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position position) {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(oldPosition.latitude, oldPosition.longitude, pos.latitude, pos.longitude);

      print('my rotation = $rotation');


      Marker movingMaker = Marker(
        markerId: MarkerId('moving'),
        position: pos,
        icon: movingMarkerIcon,
        rotation: rotation,
        infoWindow: InfoWindow(title: 'Current Location')
      );

      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 17);
        rideMapController.animateCamera(CameraUpdate.newCameraPosition(cp));

        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingMaker);
      });

      oldPosition = pos;

      updateTripDetails();

      Map locationMap = {
        'latitude': myPosition.latitude.toString(),
        'longitude': myPosition.longitude.toString(),
      };

      rideRef.child('driver_location').set(locationMap);

    });

  }

  void updateTripDetails() async{

    if(!isRequestingDirection){

      isRequestingDirection = true;

      if(myPosition == null){
        return;
      }

      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if(status == 'accepted'){
        destinationLatLng = widget.tripDetails.pickup;
      }
      else{
        destinationLatLng = widget.tripDetails.destination;
      }

      var directionDetails = await HelperMethods.getDirectionDetails(positionLatLng, destinationLatLng);

      if(directionDetails != null){

        print(directionDetails.durationText);

        setState(() {
          durationString = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;

    }

  }

  Future<void> getDirection(LatLng pickupLatLng, LatLng destinationLatLng) async {


    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(status: 'Please wait...',)
    );

    var thisDetails = await HelperMethods.getDirectionDetails(pickupLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if(results.isNotEmpty){
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polyLines.clear();

    setState(() {

      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: TaxiAppColor.colorPink,
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLines.add(polyline);

    });

    // make polyline to fit into the map

    LatLngBounds bounds;

    if(pickupLatLng.latitude > destinationLatLng.latitude && pickupLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    }
    else if(pickupLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude)
      );
    }
    else if(pickupLatLng.latitude > destinationLatLng.latitude){
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else{
      bounds = LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );


    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });

  }

  void startTimer(){
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void endTrip() async {

    saveTrip = FirebaseDatabase.instance.reference().child('driver_users/${currentFirebaseUser.currentUser.uid}/myTrips').push();

     timer.cancel();

     HelperMethods.showProgressDialog(context);

     var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

     var directionDetails = await HelperMethods.getDirectionDetails(widget.tripDetails.pickup, currentLatLng);

     Navigator.pop(context);

     // int fares = HelperMethods.estimateFares(directionDetails, durationCounter);

     // rideRef.child('tripCost').set(fares.toString());

     rideRef.child('status').set('ended');

     Map saveMyTrips = {
       'created_at': DateTime.now().toString(),
       'rider_name': widget.tripDetails.riderName,
       'rider_phone': widget.tripDetails.riderPhone,
       'rider_Photo': widget.tripDetails.riderPhoto,
       'person_number': widget.tripDetails.personNumber,
       'pickup_address': widget.tripDetails.pickupAddress,
       'destination_address': widget.tripDetails.destinationAddress,
       'payment_method': widget.tripDetails.paymentMethod,
       'rider_id': widget.tripDetails.rideID,
       'tripCost': widget.tripDetails.tripCost,
     };

     saveTrip.set(saveMyTrips);

     ridePositionStream.cancel();

     showDialog(
         context: context,
       barrierDismissible: false,
       builder: (BuildContext context) => CollectPayment(
         paymentMethod: widget.tripDetails.paymentMethod,
         tripCost: widget.tripDetails.tripCost,
       )
     );

     // topUpEarnings(fares);
  }

  void topUpEarnings(int fares){

    DatabaseReference earningsRef = FirebaseDatabase.instance.reference().child('driver_users/${currentFirebaseUser.currentUser.uid}/earnings');
    earningsRef.once().then((DataSnapshot snapshot) {

      if(snapshot.value != null){

        double oldEarnings = double.parse(snapshot.value.toString());

        double adjustedEarnings = (fares.toDouble() * 0.85) + oldEarnings;

        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }
      else{
        double adjustedEarnings = (fares.toDouble() * 0.85);
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }

    });
  }
}
