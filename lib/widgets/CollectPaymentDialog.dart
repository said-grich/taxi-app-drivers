
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/helpers/helpermethods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Taxi_App_Color.dart';
import 'BrandDivier.dart';

class CollectPayment extends StatelessWidget {

  final String paymentMethod;
  final String tripCost;

  CollectPayment({this.paymentMethod, this.tripCost});


  @override
  Widget build(BuildContext context) {

     ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(height: 20,),

            Text(
              'CASH PAYMENT',
              style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 20,),

            BrandDivider(),

            SizedBox(height: 16.0,),

            Text('\$$tripCost', style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 50),),

            SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  'Amount above is the total fares to be charged to the rider',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      color: TaxiAppColor.colorGrey
                  )
              ),
            ),

            SizedBox(height: 50,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                HelperMethods.enableHomTabLocationUpdates();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : TaxiAppColor.colorDark,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Text(
                      "Collect",
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }
}
