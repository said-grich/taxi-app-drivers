import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/globalvariabels.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Taxi_App_Color.dart';
import 'AddPhoneNumPage.dart';

class VehicleInfoPage extends StatefulWidget {


  static const String id = 'vehicleinfo';

  @override
  _VehicleInfoPageState createState() => _VehicleInfoPageState();
}

class _VehicleInfoPageState extends State<VehicleInfoPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  var carModelController = TextEditingController();

  var carColorController = TextEditingController();

  var vehicleNumberController = TextEditingController();

  void updateProfile(context){

    String id = currentFirebaseUser.currentUser.uid;
    DatabaseReference driverRef =
    FirebaseDatabase.instance.reference().child('driver_users/$id/vehicle_details');

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);

    //Take the user to the Add Debit Card Keys Page
    Navigator.pushNamed(context, AddPhoneNumPage.id);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 30,),

              SvgPicture.asset(car, height: 60, width: 60,),

              SizedBox(height: 10,),

              Text('Enter vehicle details', style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                color: TaxiAppColor.colorDark
              ),
              ),

              SizedBox(height: 40,),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(
                  controller: carModelController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "Car Model",
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(8),
                          ),
                          borderSide: BorderSide.none
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      hintStyle: TextStyle(
                          color: TaxiAppColor.colorGrey,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TaxiAppColor.colorDark
                  ),
                ),
              ),

              SizedBox(height: 10.0),

              TextField(
                controller: carColorController,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Car Color",
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide: BorderSide.none
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    hintStyle: TextStyle(
                        color: TaxiAppColor.colorGrey,
                        fontWeight: FontWeight.bold
                    )
                ),
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TaxiAppColor.colorDark
                ),
              ),

              SizedBox(height: 10.0),

              TextField(
                controller: vehicleNumberController,
                maxLength: 11,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Car Number",
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide: BorderSide.none
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    hintStyle: TextStyle(
                        color: TaxiAppColor.colorGrey,
                        fontWeight: FontWeight.bold
                    )
                ),
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TaxiAppColor.colorDark
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: (){

                  if(carModelController.text.length < 3){
                    showSnackBar('Please provide a valid car model');
                    return;
                  }

                  if(carColorController.text.length < 3){
                    showSnackBar('Please provide a valid car color');
                    return;
                  }

                  if(vehicleNumberController.text.length < 3){
                    showSnackBar('Please provide a valid vehicle number');
                    return;
                  }

                  updateProfile(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: TaxiAppColor.colorDark,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
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
