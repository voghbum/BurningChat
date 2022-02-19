import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;

abstract class AuthBase {
  Future<MyUser.User> currentUser();

  Future<MyUser.User> signInAnonymously();

  Future<bool> signOut();

  Future<MyUser.User> signInWithGoogle();

  Future<MyUser.User> signInWithEmailandPassword(String email, String sifre);

  Future<MyUser.User> createWithEmailandPassword(String email, String sifre);
}
