import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Color highlightColor;
  final Widget buttonIcon;
  final VoidCallback onpressed;

  const SocialLoginButton(
      {Key key,
      this.buttonText: " ",
      this.buttonColor: Colors.white,
      this.textColor: Colors.black,
      this.highlightColor: Colors.white,
      this.buttonIcon,
      this.onpressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(4),
      height: 50,
      child: RaisedButton(
        onPressed: onpressed,
        textColor: textColor,
        highlightColor: highlightColor,
        color: buttonColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttonIcon,
            Text(buttonText,style: TextStyle(fontSize: 16),),
            Opacity(
              opacity: 0,
              child: buttonIcon,
            )
          ],
        ),
        shape: StadiumBorder(),
      ),
    );
  }
}
