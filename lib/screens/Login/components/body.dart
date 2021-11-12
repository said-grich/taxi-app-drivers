import 'package:cabdriver/Taxi_App_Color.dart';
import 'package:cabdriver/screens/Login/components/background.dart';
import 'package:cabdriver/screens/Signup/signup_screen.dart';
import 'package:cabdriver/screens/companents/already_have_an_account_acheck.dart';
import 'package:cabdriver/screens/companents/rounded_button.dart';
import 'package:cabdriver/screens/companents/rounded_input_field.dart';
import 'package:cabdriver/screens/companents/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatelessWidget {

  final TextEditingController  _emailController= TextEditingController();
  final TextEditingController  _passwordController= TextEditingController();
  Future<bool> regesteruser(){
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: GoogleFonts.fugazOne(
                  fontSize: 35,
                  color: TaxiAppColor.colorPink
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "images/taxi-svg.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controler: _emailController,
              icon: Icons.phone,
              hintText: "Phone number",
              onChanged: (value)=>{
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () =>{
                print(_emailController.text)
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
