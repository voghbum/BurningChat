import 'package:f_mesajlasma_uygulamasi/app/chat_page.dart';
import 'package:f_mesajlasma_uygulamasi/common_widget/social_login_buttons.dart';
import 'package:f_mesajlasma_uygulamasi/models/konusma.dart' as Model;
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:f_mesajlasma_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("konuşmalarım"),
      ),
      body: FutureBuilder<List<Model.Konusma>>(
        future: _userViewModel.getAllConversations(_userViewModel.user.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;

            if (tumKonusmalar.length > 0) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, right: 5, left: 5, bottom: 6),
                child: RefreshIndicator(
                    child: ListView.builder(
                      itemCount: tumKonusmalar.length,
                      itemBuilder: (context, index) {
                        var oankiKonusma = tumKonusmalar[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.grey.shade300,
                                    blurRadius: 15,
                                    spreadRadius: 7),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  colorFromHex("#E1CC90"),
                                  //colorFromHex("#F7B8AB"),
                                  //colorFromHex("#BEE6C8"),
                                  //colorFromHex("#D4BEE6"),
                                  //colorFromHex("#E5E6BE"),
                                  colorFromHex("#F3FBE6"),
                                ],
                              ),
                            ),
                            child: ListTile(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                        create: (context) => ChatViewModel(
                                          currentUser: _userViewModel.user,
                                          oppositeUser: MyUser.User(
                                              userID:
                                                  oankiKonusma.kimleKonusuyor),
                                        ),
                                        child: ChatPage(
                                            oankiKonusma.konusulanUserName),
                                      ),
                                    ),
                                  );
                                },
                                title: Text(oankiKonusma.sonMesaj),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      oankiKonusma.konusulanUserName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700),
                                    ),
                                    Text(oankiKonusma.aradakiFark)
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
                    onRefresh: _konusmalarimListesiniYenile),
              );
            } else {
              return RefreshIndicator(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              size: 120,
                            ),
                            Text("Konuşma Yok!")
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ),
                  onRefresh: _konusmalarimListesiniYenile);
            }
          }
        },
      ),
    );
  }

  Future<void> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
