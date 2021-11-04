
import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/screens/MainPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Taxi_App_Color.dart';
import '../globalvariabels.dart';


class AddPhoneNumPage extends StatefulWidget {


  static const String id = 'AddPhoneNumPage';

  @override
  _AddPhoneNumPageState createState() => _AddPhoneNumPageState();
}

class _AddPhoneNumPageState extends State<AddPhoneNumPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  var phoneNumberController = TextEditingController();


  void updateProfile(context){

    String id = currentFirebaseUser.currentUser.uid;
    DatabaseReference driverRef =
    FirebaseDatabase.instance.reference().child('driver_users/$id/phone');

    Map map = {
      'phoneNumber': phoneNumberController.text,
    };

    driverRef.set(map);

    // Take user to the Main Page
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);


  }

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 30,),

            SvgPicture.asset(call, height: 40, width: 40, color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),

            SizedBox(height: 10,),

            Text('Add your Phone Number', style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
            ),
            ),

            SizedBox(height: 40,),

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Phone Number",
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide: BorderSide.none
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    hintStyle: TextStyle(
                        color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorGrey,
                        fontWeight: FontWeight.bold
                    )
                ),
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                ),
              ),
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: (){

                if(phoneNumberController.text.length < 7){
                  showSnackBar('Please provide a valid Phone Number');
                  return;
                }

                updateProfile(context);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDarkLight,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Text(
                    "Finish",
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
    );
  }
}
