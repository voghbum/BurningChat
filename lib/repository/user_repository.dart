import 'dart:io';
import 'package:f_mesajlasma_uygulamasi/locator.dart';
import 'package:f_mesajlasma_uygulamasi/models/konusma.dart';
import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:f_mesajlasma_uygulamasi/services/auth_base.dart';
import 'package:f_mesajlasma_uygulamasi/services/bildirim_gonderme_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/fake_auth_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/firebase_auth_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/firebase_storage_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/firestore_db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  BildirimGondermeSevice _bildirimGondermeSevice =
      locator<BildirimGondermeSevice>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  AppMode _appMode = AppMode.RELEASE;
  List<MyUser.User> tumkullaniciListesi = [];
  Map<String, String> kullaniciToken = Map<String, String>();

  @override
  Future<MyUser.User> currentUser() async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return _fakeAuthService.currentUser();
        break;
      case AppMode.RELEASE:
        MyUser.User _user = await _firebaseAuthService.currentUser();
        return _user != null
            ? await _firestoreDBService.readUser(_user.userID)
            : null;
    }
    throw UnimplementedError();
  }

  @override
  Future<MyUser.User> signInAnonymously() async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return await _fakeAuthService.signInAnonymously();
        break;
      case AppMode.RELEASE:
        return await _firebaseAuthService.signInAnonymously();
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Future<bool> signOut() async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return await _fakeAuthService.signOut();
        break;
      case AppMode.RELEASE:
        return await _firebaseAuthService.signOut();
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Future<MyUser.User> signInWithGoogle() async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return await _fakeAuthService.signInWithGoogle();
        break;
      case AppMode.RELEASE:
        MyUser.User _user =
            await _firebaseAuthService.signInWithGoogle(); // null dönüyor
        if (_user != null) {
          bool _sonuc = await _firestoreDBService.saveUser(_user);
          if (_sonuc) {
            return await _firestoreDBService.readUser(_user.userID);
          } else {
            await _firebaseAuthService.signOut();
            return null;
          }
        } else
          return null;
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Future<MyUser.User> createWithEmailandPassword(
      String email, String sifre) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return await _fakeAuthService.createWithEmailandPassword(email, sifre);
        break;
      case AppMode.RELEASE:
        MyUser.User _user =
            await _firebaseAuthService.createWithEmailandPassword(email, sifre);
        bool _sonuc = await _firestoreDBService.saveUser(_user);
        if (_sonuc) {
          return await _firestoreDBService.readUser(_user.userID);
        } else
          return null;
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Future<MyUser.User> signInWithEmailandPassword(
      String email, String sifre) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return await _fakeAuthService.signInWithEmailandPassword(email, sifre);
        break;
      case AppMode.RELEASE:
        MyUser.User _user =
            await _firebaseAuthService.signInWithEmailandPassword(email, sifre);
        return _firestoreDBService.readUser(_user.userID);
        break;
      default:
        return null;
        break;
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return false;
        break;
      case AppMode.RELEASE:
        bool sonuc =
            await _firestoreDBService.updateUserName(userID, yeniUserName);
        MyUser.User user = await _firestoreDBService.readUser(userID);
        debugPrint("\n\n\n YENİ  " + user.userName);
        return sonuc;
        break;
      default:
        return null;
        break;
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        break;
      case AppMode.RELEASE:
        var profilFotoUrl = await _firebaseStorageService.uploadFile(
            userID, fileType, profilFoto);
        print("ÇALIŞTI\n\n");
        await _firestoreDBService.updateProfilPhoto(userID, profilFotoUrl);
        return profilFotoUrl;
        break;
      default:
        return null;
        break;
    }
    return null;
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String oppositeUserID) {
    switch (_appMode) {
      case AppMode.DEBUG:
        return Stream.empty();
        break;
      case AppMode.RELEASE:
        return _firestoreDBService.getMessages(currentUserID, oppositeUserID);
        break;
      default:
        return null;
        break;
    }
  }

  Future<bool> saveMessage(
      Mesaj kaydedilecekMesaj, MyUser.User currentUser) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return true;
        break;
      case AppMode.RELEASE:
        var dbYazmaIslemi =
            await _firestoreDBService.saveMessage(kaydedilecekMesaj);
        if (dbYazmaIslemi) {
          var token = "";
          if (kullaniciToken.containsKey(kaydedilecekMesaj.kime)) {
            token = kullaniciToken[kaydedilecekMesaj.kime];
          } else {
            token =
                await _firestoreDBService.tokenGetir(kaydedilecekMesaj.kime);
            kullaniciToken[kaydedilecekMesaj.kime] = token;
          }
          await _bildirimGondermeSevice.bildirimGonder(
              kaydedilecekMesaj, currentUser, token);
          return true;
        } else
          return false;

        break;
      default:
        return null;
        break;
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return await Future.value(List<Konusma>());
        break;
      case AppMode.RELEASE:
        DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

        var konusmaListesi =
            await _firestoreDBService.getAllConversations(userID);

        for (var oAnkiKonusma in konusmaListesi) {
          var userListesindekiKullanici =
              listedeUserBul(oAnkiKonusma.kimleKonusuyor);

          if (userListesindekiKullanici != null) {
            oAnkiKonusma.konusulanUserName = userListesindekiKullanici.userName;

            oAnkiKonusma.konusulanUserProfilURL =
                userListesindekiKullanici.profilURL;
          } else {
            print(
                "aranılan user getirilmemiş, bu yüzden veritabanından bu degeri okumalıyız..");
            var _veritabanindanOkunanUser =
                await _firestoreDBService.readUser(oAnkiKonusma.kimleKonusuyor);
            oAnkiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
            oAnkiKonusma.konusulanUserProfilURL =
                _veritabanindanOkunanUser.profilURL;
          }
          timeagoHesapla(oAnkiKonusma, _zaman);
        }
        return konusmaListesi;
        break;
      default:
        return null;
        break;
    }
  }

  MyUser.User listedeUserBul(String userID) {
    for (int i = 0; i < tumkullaniciListesi.length; i++) {
      if (tumkullaniciListesi[i].userID == userID) {
        return tumkullaniciListesi[i];
      }
    }

    return null;
  }

  void timeagoHesapla(Konusma oAnkiKonusma, DateTime zaman) {
    try {
      oAnkiKonusma.sonOkunmaZamani = zaman;
      timeago.setLocaleMessages("tr", timeago.TrMessages());
      var _duration = zaman.difference(oAnkiKonusma.olusturulmaTarihi.toDate());
      debugPrint(
          "deger = " + timeago.format(zaman.subtract(_duration), locale: "tr"));
      oAnkiKonusma.aradakiFark =
          timeago.format(zaman.subtract(_duration), locale: "tr");
    } catch (e) {
      debugPrint("HATA: " + e.toString());
    }
  }

  Future<List<MyUser.User>> getUserWithPagination(
      MyUser.User enSonGetirilenUser,
      int sayfadakiGetirilecekElemanSayisi) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return [];
        break;
      case AppMode.RELEASE:
        List<MyUser.User> _userList =
            await _firestoreDBService.getUserWithPagination(
                enSonGetirilenUser, sayfadakiGetirilecekElemanSayisi);
        tumkullaniciListesi.addAll(_userList);
        return _userList;
        break;
      default:
        return null;
        break;
    }
  }

  Future<List<Mesaj>> getMessagesWithPagination(
      String currentUserID,
      String oppositeUserID,
      Mesaj enSonGetirilenMesaj,
      int sayfaBasinaGetirilecekElemanSayisi) async {
    switch (_appMode) {
      case AppMode.DEBUG:
        return [];
        break;
      case AppMode.RELEASE:
        return await _firestoreDBService.getMessagesWithPagination(
            currentUserID,
            oppositeUserID,
            enSonGetirilenMesaj,
            sayfaBasinaGetirilecekElemanSayisi);
        break;
      default:
        return null;
        break;
    }
  }
}
