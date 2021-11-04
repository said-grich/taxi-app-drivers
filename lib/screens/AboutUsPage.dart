import 'package:cabdriver/TaxiApp_Icons/TaxiApp_Icons.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Taxi_App_Color.dart';

class AboutUsPage extends StatefulWidget {

  static String id = "AboutUsPage";

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  String _launchInstaApp = "https://www.instagram.com/adnantjee.xx/";

  // open Instagram app
  Future<void> launchInstagram(String url) async{

    if( await canLaunch(url)){
      await launch(
        url,
        forceWebView: false,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
    }else{
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.asset("images/Adnantjeexx.jpg",
                      height: 80,
                      width: 80,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Adnantjee.xx",
                    style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "Flutter Developer & UI Designer",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: TaxiAppColor.colorGrey
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchInstagram(_launchInstaApp);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : TaxiAppColor.colorDark,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(instagram, height: 20, width: 20, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text(
                            "Instagram",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
