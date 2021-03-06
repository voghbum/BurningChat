import 'dart:io';
import 'package:f_mesajlasma_uygulamasi/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:f_mesajlasma_uygulamasi/common_widget/social_login_buttons.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilFoto;
  final ImagePicker _picker = ImagePicker();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _fotoSec(ImageSource source) async {
    var _pickedFoto = await _picker.getImage(source: source);

    setState(() {
      _profilFoto = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel = Provider.of<UserViewModel>(context);
    _controllerUserName.text = _userModel.user.userName;
    //print("Profil sayfasındaki user degerleri :" + _userModel.user.toString());
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profil"),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _fotoSec(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _fotoSec(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: _profilFoto == null
                        ? NetworkImage(_userModel.user.profilURL)
                        : FileImage(_profilFoto),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  buttonColor: Colors.orange,
                  highlightColor: Colors.orange.shade700,
                  buttonIcon: Container(),
                  buttonText: "Değişiklikleri Kaydet",
                  onpressed: () {
                    _userNameGuncelle(context, _userModel);
                    _profilFotoGuncelle(context, _userModel);
                    ///////////////////
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text(
                        "Değişiklikler kaydedildi",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      duration: Duration(seconds: 1, milliseconds: 500),
                      backgroundColor: Colors.green.shade700,
                    ));
                    ///////////////////////7
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  highlightColor: Colors.red,
                  buttonColor: Colors.red.shade600,
                  buttonIcon: Container(),
                  buttonText: "Çıkış Yap",
                  onpressed: () => _cikisIcinOnayIste(context, _userModel),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context, UserViewModel _userModel) async {
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(
      BuildContext context, UserViewModel _userModel) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context, _userModel);
    }
  }

  void _userNameGuncelle(BuildContext context, UserViewModel _userModel) async {
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);

      if (updateResult == true) {
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "bu kullanıcı adı zaten kullanımda, farklı bir username deneyiniz",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle(
      BuildContext context, UserViewModel _userModel) async {
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user.userID, "profil_foto", _profilFoto);
      //print("gelen url :" + url);

      if (url != null) {}
    }
  }
}
