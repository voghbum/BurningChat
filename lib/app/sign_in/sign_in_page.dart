import 'package:f_mesajlasma_uygulamasi/app/sign_in/email_sifre_giris_ve_kayit.dart';
import 'package:f_mesajlasma_uygulamasi/common_widget/social_login_buttons.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  void _gmailGirisi(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    MyUser.User _user = await _userViewModel.signInWithGoogle();
    if (_user != null) debugPrint("gmailGirisi id: " + _user.userID);
  }

  void _emailGirisi(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailveSifreLoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            "BURNING CHAT",
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.amber[900],
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oturum açın",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 29,
              ),
            ),
            SizedBox(height: 50),
            SocialLoginButton(
              buttonColor: colorFromHex("#DB4437"),
              buttonText: "Google ile giriş yap",
              textColor: Colors.white,
              highlightColor: colorFromHex("#6d221b"),
              onpressed: () {
                _gmailGirisi(context);
              },
              buttonIcon: Image.asset(
                "images/google_icon.png",
                height: 25,
              ),
            ),
            SocialLoginButton(
              buttonColor: colorFromHex("49796b"),
              buttonText: "Email ile giriş yap",
              textColor: Colors.white,
              highlightColor: colorFromHex("243c35"),
              onpressed: () {
                _emailGirisi(context);
              },
              buttonIcon: Icon(
                Icons.mail,
                color: Colors.white,
                size: 31,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
