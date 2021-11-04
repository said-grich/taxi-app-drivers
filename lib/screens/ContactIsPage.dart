import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Taxi_App_Color.dart';
import '../globalvariabels.dart';

class ContactUsPage extends StatefulWidget {

  static String id = "ContactUsPage";

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var subjectController = TextEditingController();
  var messageController = TextEditingController();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 15),),
      duration: Duration(seconds: 10),
      backgroundColor: TaxiAppColor.colorGreen,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void sendData(context){


    String id = currentFirebaseUser.currentUser.uid;
    DatabaseReference driverRef =
    FirebaseDatabase.instance.reference().child('contactUs_box/$id');

    Map map = {
      'subject': subjectController.text,
      'message': messageController.text,
      'userName': currentFirebaseUser.currentUser.displayName,
      'userEmail': currentFirebaseUser.currentUser.email,
    };

    driverRef.set(map);

  }

  @override
  Widget build(BuildContext context) {

     ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    contactUs, height: 50, width: 50,
                    color: themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "How Can us help you!",
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      controller: subjectController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Subject",
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
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Message",
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
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){

                      sendData(context);

                      showSnackBar("message sent successfully, after review your message we will send you to your email account, have a nice day");

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : TaxiAppColor.colorDark,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          "Send",
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
        ),
      ),
    );
  }
}
