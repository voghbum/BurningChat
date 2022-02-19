import 'package:f_mesajlasma_uygulamasi/app/chat_page.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/all_users_view_model.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("kullanıcılar"),
      ),
      body: Consumer<AllUsersViewModel>(
        builder: (context, allUsersViewModel, child) {
          if (allUsersViewModel.state == AllUserViewState.Busy) {
            print("\n\nprogressde");
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (allUsersViewModel.state == AllUserViewState.Loaded) {
            print("\n\nLoaded if girdi");
            return RefreshIndicator(
              onRefresh: allUsersViewModel.refresh,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (allUsersViewModel.kullanicilarListesi.length == 1) {
                    return kullaniciYokUi();
                  } else if (allUsersViewModel.hasMoreLoading &&
                      allUsersViewModel.kullanicilarListesi.length == index) {
                    return _yeniElemanlarYukleniyorIndicator();
                  } else {
                    return _listeElemanlariniOlustur(context, index);
                  }
                },
                itemCount: allUsersViewModel.hasMoreLoading
                    ? allUsersViewModel.kullanicilarListesi.length + 1
                    : allUsersViewModel.kullanicilarListesi.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    var _userViewModel = Provider.of<UserViewModel>(context);
    var _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    MyUser.User oankiUser = _allUsersViewModel.kullanicilarListesi[index];

    // İf sonradan Eklendi Çalışmayabilir !!!!!!
    if (oankiUser.userID == _userViewModel.user.userID) {
      return Container();
    }
    // !!!!!!!
    else {
      return makeCard(oankiUser, _userViewModel, index);
    }
  }

  Card makeCard(
      MyUser.User oankiUser, UserViewModel _userViewModel, int index) {
    return Card(
      elevation: 3,
      margin: new EdgeInsets.symmetric(horizontal: 5, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<ChatViewModel>(
                    create: (context) => ChatViewModel(
                        currentUser: _userViewModel.user,
                        oppositeUser: oankiUser),
                    child: ChatPage(oankiUser.userName),
                  ),
                ),
              );
            },
            //contentPadding:
            //  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilResmi(oankiUser.profilURL, index),
                ),
              ),
              child: Hero(
                tag: "profil_resmi$index",
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 0.5, color: Colors.grey.shade600))),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(oankiUser.profilURL),
                  ),
                ),
              ),
            ),
            title: Text(
              oankiUser.userName,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.mail,
                  color: Colors.orange.shade500,
                  size: 19,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(oankiUser.email,
                    style: TextStyle(color: Colors.grey.shade800))
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 30.0)),
      ),
    );
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void dahaFazlaKullaniciGetir() async {
    if (!_isLoading) {
      _isLoading = true;
      final _allUsersViewModel =
          Provider.of<AllUsersViewModel>(context, listen: false);
      await _allUsersViewModel.dahaFazlaUserGetir();
      _isLoading = false;
    }
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      dahaFazlaKullaniciGetir();
    }
  }

  Widget kullaniciYokUi() {
    AllUsersViewModel allUsersViewModel =
        Provider.of<AllUsersViewModel>(context);
    return RefreshIndicator(
      onRefresh: allUsersViewModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.supervised_user_circle,
                    size: 70, color: Colors.grey.shade700),
                Text(
                  "Kullanıcı Yok",
                  style: TextStyle(fontSize: 50, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );
  }
}

class ProfilResmi extends StatelessWidget {
  final String profilURL;
  final int index;

  ProfilResmi(this.profilURL, this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: "profil_resmi$index",
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(profilURL),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
