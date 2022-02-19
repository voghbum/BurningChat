import 'package:f_mesajlasma_uygulamasi/app/home_page.dart';
import 'package:f_mesajlasma_uygulamasi/app/sign_in/sign_in_page.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.state == ViewState.Idle) {
      if (_userViewModel.user == null) {
        return SignInPage();
      } else {
        return HomePage();
      }
    } else {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }
}

/*
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  MyUser.User _user;
  AuthBase authService = locator<FirebaseAuthService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSignIn: (MyUser.User user) {
          _updateUser(user);
        },
      );
    } else {
      return HomePage(
        onSignOut: () {
          _updateUser(null);
        },
      );
    }
  }

  Future<void> _checkUser() {
    _user = authService.currentUser();
    return null;
  }

  void _updateUser(MyUser.User user) {
    setState(() {
      _user = user;
    });
  }
}
 */
