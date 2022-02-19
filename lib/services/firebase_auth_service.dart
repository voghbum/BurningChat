import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:f_mesajlasma_uygulamasi/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyUser.User _myUserFromFirebaseUser(User user) {
    if (user == null) {
      return null;
    } else {
      return MyUser.User(userID: user.uid, email: user.email);
    }
  }

  @override
  Future<MyUser.User> currentUser() async {
    User user = _firebaseAuth.currentUser;
    return await Future.value(_myUserFromFirebaseUser(user));
  }

  @override
  Future<MyUser.User> signInAnonymously() async {
    UserCredential credential = await _firebaseAuth.signInAnonymously();
    return _myUserFromFirebaseUser(credential.user);
  }

  @override
  Future<bool> signOut() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    return true;
  }

  @override
  Future<MyUser.User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser;
    try {
      _googleUser = await _googleSignIn.signIn(); // hata burada

    } catch (e) {
      print("hata:\n" + e.toString());
    }
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.accessToken != null && _googleAuth.idToken != null) {
        UserCredential credential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        return _myUserFromFirebaseUser(credential.user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<MyUser.User> createWithEmailandPassword(String email,
      String sifre) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: sifre);
    return _myUserFromFirebaseUser(credential.user);
  }

  @override
  Future<MyUser.User> signInWithEmailandPassword(String email,
      String sifre) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _myUserFromFirebaseUser(credential.user);
  }
}
