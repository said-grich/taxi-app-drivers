import 'package:cabdriver/screens/companents/text_field_container.dart';
import 'package:flutter/material.dart';

import '../../Taxi_App_Color.dart';
import '../../brand_colors.dart';


class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: TaxiAppColor.colorDarkLight,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: TaxiAppColor.colorDarkLight,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
