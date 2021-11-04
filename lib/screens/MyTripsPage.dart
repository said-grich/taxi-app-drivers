import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/widgets/BrandDivier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Taxi_App_Color.dart';
import '../globalvariabels.dart';


class MyTripsPage extends StatefulWidget {

  static String id = "MyTripsPage";

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {

  DatabaseReference reference = FirebaseDatabase.instance.reference().child("driver_users");

  Query ref;
  DataSnapshot dataSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = FirebaseDatabase.instance.reference().child("driver_users/${currentFirebaseUser.currentUser.uid}/myTrips");
    ref.orderByChild("driver_name");
    checkEmptyList();
  }

  void checkEmptyList() async {
    dataSnapshot = await ref.once();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

     ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, size: 30,)
                      ),
                      SizedBox(width: 10,),
                      Text('My Trips',
                        style: GoogleFonts.fugazOne(fontSize: 35,),
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: (){
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
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [

                                        Text('Delete All Trips',
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
                                            'are you sure you want to delete All this Trips',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              color: TaxiAppColor.colorGrey
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 30,),

                                        GestureDetector(
                                          onTap: (){
                                            reference
                                                .child(currentFirebaseUser.currentUser.uid)
                                                .child("myTrips")
                                                .remove()
                                                .whenComplete(() => Navigator.pop(context));

                                            setState(() {
                                              checkEmptyList();
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: TaxiAppColor.colorPink,
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  delete, height: 20,width: 20,
                                                  color: TaxiAppColor.colorPink,
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                  "Delete",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: TaxiAppColor.colorPink,
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
                      child: SvgPicture.asset(
                        delete, height: 25, width: 25,
                        color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                      )
                  ),
                ],
              ),
              SizedBox(height: 20,),
              dataSnapshot?.value == null
                  ? Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                        "you have No Trips yet",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: TaxiAppColor.colorGrey
                      ),
                    ),
              )
                  : Expanded(
                    child: Container(
                      child: FirebaseAnimatedList(
                      query: ref,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(12),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      var tripData = snapshot.value;
                      tripData['key'] = snapshot.key;
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 130,
                              margin: EdgeInsets.only(left: 10),
                              child: Center(
                                  child: Text(
                                    "${tripData["created_at"].toString().substring(0,16)}",
                                    style: GoogleFonts.lato(
                                    fontSize: 16,
                                    ),
                                  )
                              )
                          ),
                          SizedBox(height: 10,),
                          cardItem(tripData, themeProvider),
                        ],
                      );
                    },

                ),
              ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardItem(Map tripData, ThemeProvider themeProvider){

    return Container(
      height: 240,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0,3),
                blurRadius: 20
            )
          ]
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: tripData["rider_Photo"],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tripData["rider_name"].toString(),
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 7,),
                          Row(
                            children: [
                              SvgPicture.asset(star, height: 18,width: 18,color: TaxiAppColor.colorYellow,),
                              SizedBox(width: 5,),
                              Text(
                                "4.5",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: TaxiAppColor.colorGrey
                                ),
                              )
                            ],
                          )
                        ],
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
                      "US" + "\$${tripData["tripCost"]}",
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
            SizedBox(height: 15,),
            BrandDivider(),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                children: [
                  SvgPicture.asset(pickIcon, color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),
                  SizedBox(width: 10,),
                  Text(
                    tripData["pickup_address"].toString(),
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        color: TaxiAppColor.colorGrey
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
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
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 4.5),
              child: Row(
                children: [
                  SvgPicture.asset(destIcon, height: 24, width: 24,color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),
                  SizedBox(width: 10,),
                  Text(
                    tripData["destination_address"].toString(),
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        color: TaxiAppColor.colorGrey
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 5.5),
              child: Row(
                children: [
                  SvgPicture.asset(
                    person,
                    height: 23,
                    width: 23,
                    color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    tripData["person_number"].toString(),
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: TaxiAppColor.colorGrey
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
