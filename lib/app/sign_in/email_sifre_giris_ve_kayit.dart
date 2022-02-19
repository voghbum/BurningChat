import 'package:f_mesajlasma_uygulamasi/app/hatalar_exception.dart';
import 'package:f_mesajlasma_uygulamasi/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:f_mesajlasma_uygulamasi/common_widget/social_login_buttons.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { REGISTER, LOGIN }

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _buttonText, _linkText, _appBarText;
  FormType _formType = FormType.LOGIN;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit(UserViewModel _userViewModel) async {
    _formKey.currentState.save();
    debugPrint(_email + "\n" + _sifre);
    if (_formType == FormType.REGISTER) {
      try {
        await _userViewModel.createWithEmailandPassword(_email, _sifre);
      } on FirebaseAuthException catch (e) {
        PlatformDuyarliAlertDialog(
                baslik: "kullanıcı kayıt hata",
                icerik: Hatalar.goster(e.code),
                anaButonYazisi: "tamam")
            .goster(context);
      }
    } else {
      try {
        await _userViewModel.signInWithEmailandPassword(_email, _sifre);
      } on FirebaseAuthException catch (e) {
        PlatformDuyarliAlertDialog(
                baslik: "kullanıcı girişi hata",
                icerik: Hatalar.goster(e.code),
                anaButonYazisi: "tamam")
            .goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LOGIN ? FormType.REGISTER : FormType.LOGIN;
      debugPrint(_formType.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    _buttonText = _formType == FormType.LOGIN ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LOGIN
        ? "Hesabınız yok mu? Hemen kayıt olun"
        : "Zaten bir hesabınız mı var? Giriş yapın";
    _appBarText = _formType == FormType.LOGIN ? "Giriş Yapın" : "Kayıt olun";

    if (_userViewModel.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_appBarText),
        centerTitle: true,
      ),
      body: _userViewModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _userViewModel.emailHataMesaji != null
                              ? _userViewModel.emailHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email",
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String girilenEmail) {
                          _email = girilenEmail;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: _userViewModel.sifreHataMesaji != null
                              ? _userViewModel.sifreHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.keyboard),
                          hintText: "Şifre",
                          labelText: "Şifre",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String girilensifre) {
                          _sifre = girilensifre;
                        },
                      ),
                      SizedBox(height: 16),
                      SocialLoginButton(
                        buttonText: _buttonText,
                        buttonColor: Theme.of(context).buttonColor,
                        highlightColor: Theme.of(context).highlightColor,
                        buttonIcon: Container(),
                        onpressed: () {
                          _formSubmit(_userViewModel);
                        },
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        onPressed: () {
                          _degistir();
                        },
                        child: Text(
                          _linkText,
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
