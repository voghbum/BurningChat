import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:f_mesajlasma_uygulamasi/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  @override
  Future<MyUser.User> currentUser() async{
    return await Future.value(MyUser.User(userID: "123456", email: "debug@mail.com",));
  }

  @override
  Future<MyUser.User> signInAnonymously() {
    return Future.delayed(Duration(seconds: 1)).then(
        (value) => MyUser.User(userID: "123456", email: "debug@mail.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.delayed(Duration(seconds: 1)).then((value) => true);
  }

  @override
  Future<MyUser.User> signInWithGoogle() {
    return Future.delayed(Duration(seconds: 1)).then(
        (value) => MyUser.User(userID: "123456", email: "debug@mail.com"));
  }

  @override
  Future<MyUser.User> createWithEmailandPassword(String email, String sifre) {
    return Future.delayed(Duration(seconds: 1)).then(
        (value) => MyUser.User(userID: "123456", email: "debug@mail.com"));
  }

  @override
  Future<MyUser.User> signInWithEmailandPassword(String email, String sifre) {
    return Future.delayed(Duration(seconds: 1)).then(
        (value) => MyUser.User(userID: "123456", email: "debug@mail.com"));
  }
}
