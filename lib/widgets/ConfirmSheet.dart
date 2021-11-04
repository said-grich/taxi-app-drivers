import 'package:cabdriver/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Taxi_App_Color.dart';

class ConfirmSheet extends StatelessWidget {

  final String title;
  final String subtitle;
  final Function onPressed;

  ConfirmSheet({this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0, // soften the shadow
            spreadRadius: 0.5, //extend the shadow
            offset: Offset(
              0.7, // Move to right 10  horizontally
              0.7, // Move to bottom 10 Vertically
            ),
          )
        ],

      ),
      height: 220,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[

            SizedBox(height:  10,),

           Text(
             title,
             textAlign: TextAlign.center,
             style: GoogleFonts.lato(
                 fontSize: 22,
                 color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                 fontWeight: FontWeight.bold),
           ),

            SizedBox(height: 20,),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(color: TaxiAppColor.colorGrey),
            ),

            SizedBox(height: 24,),

            Row(
              children: <Widget>[

                Expanded(
                  child: GestureDetector(
                    onTap: (){
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
                          "CANCEL",
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


                SizedBox(width: 16,),

                Expanded(
                  child: GestureDetector(
                    onTap: onPressed,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: (title == 'GO ONLINE') ? TaxiAppColor.colorGreen : TaxiAppColor.colorPink,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          "CONFIRM",
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



              ],
            )

          ],
        ),
      ),
    );
  }
}
