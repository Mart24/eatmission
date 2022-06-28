import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/views/constants.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final Widget text;

  const CustomButton({
    Key key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        fixedSize: MaterialStateProperty.all<Size>(
            Size(MediaQuery.of(context).size.width * 0.4, 30)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      onPressed: onPressed,
      child: text,
    );
  }
}
