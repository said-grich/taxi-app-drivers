import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Taxi_App_Color.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/datamodels/tripdetails.dart';
import 'package:cabdriver/globalvariabels.dart';
import 'package:cabdriver/helpers/helpermethods.dart';
import 'package:cabdriver/screens/newtripspage.dart';
import 'package:cabdriver/widgets/ProgressDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {

  final TripDetails tripDetails;
  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : TaxiAppColor.colorWhiteLite,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 65,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(car, height: 35, width: 35,),
                      SizedBox(width: 10,),
                      Text(
                        "NEW TRIP",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Now",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                      color: TaxiAppColor.colorGreen
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: tripDetails.riderPhoto,
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
                          width: 10,
                        ),
                        Text(
                          tripDetails.riderName,
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Trip Cost",
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: TaxiAppColor.colorGrey
                        ),
                      ),
                      Text(
                        "US" + "\$${tripDetails.tripCost.toString()}",
                        style: GoogleFonts.lato(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorGreen : TaxiAppColor.colorDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
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
                            tripDetails.pickupAddress,
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
                            tripDetails.destinationAddress,
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
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                children: [
                  SvgPicture.asset(person, height: 25, width: 25, color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),
                  SizedBox(width: 10,),
                  Text(
                    tripDetails.personNumber,
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: TaxiAppColor.colorGrey
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        assetsAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        assetsAudioPlayer.stop();
                        checkAvailablity(context);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : TaxiAppColor.colorDark,
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Accept",
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

            SizedBox(height: 25),

          ],
        ),
      ),
    );
  }

  void checkAvailablity(context){

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Accepting request',),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance.reference().child('driver_users/${currentFirebaseUser.currentUser.uid}/newtrip');
    newRideRef.once().then((DataSnapshot snapshot) {

      Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = "";
      if(snapshot.value != null){
        thisRideID = snapshot.value.toString();
      }
      else{
        Toast.show("Ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

      if(thisRideID == tripDetails.rideID){
        newRideRef.set('accepted');
        HelperMethods.disableHomTabLocationUpdates();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewTripPage(tripDetails: tripDetails,),
        ));
      }
      else if(thisRideID == 'cancelled'){
        Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      else if(thisRideID == 'timeout'){
        Toast.show("Ride has timed out", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      else{
        Toast.show("Ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

    });
  }

}
