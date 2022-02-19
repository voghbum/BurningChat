import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_mesajlasma_uygulamasi/models/konusma.dart';
import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:f_mesajlasma_uygulamasi/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser.User user) async {
    DocumentSnapshot _okunanUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}/").get();

    if (_okunanUser.data() == null) {
      await _firestoreDB.collection("users").doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<MyUser.User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firestoreDB.collection("users").doc(userID).get();
    Map<String, dynamic> okunanUserBilgileriMap = _okunanUser.data();

    MyUser.User _user = MyUser.User.fromMap(okunanUserBilgileriMap);
    return _user;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firestoreDB
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({"userName": yeniUserName});
    }
    return true;
  }

  updateProfilPhoto(String userID, String profilFotoUrl) async {
    await _firestoreDB
        .collection("users")
        .doc(userID)
        .update({"profilURL": profilFotoUrl});

    return true;
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firestoreDB.collection("konusmalar").doc().id;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();

    await _firestoreDB
        .collection("konusmalar")
        .doc(_myDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    await _firestoreDB.collection("konusmalar").doc(_myDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (value) => false);

    await _firestoreDB.collection("konusmalar").doc(_receiverDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    await _firestoreDB
        .collection("konusmalar")
        .doc(_receiverDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    return true;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    var konusmalarim = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    List<Konusma> tumKonusmalar = [];
    for (DocumentSnapshot tekKonusma in konusmalarim.docs) {
      Konusma _tekKonusma = Konusma.fromMap(tekKonusma.data());
      tumKonusmalar.add(_tekKonusma);
    }
    return tumKonusmalar;
  }

  // Bunda Hiçbir SIKINTI YOKK !!!

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firestoreDB
        .collection("server")
        .doc(userID)
        .set({"saat": FieldValue.serverTimestamp()});
    var okunanMap = await _firestoreDB.collection("server").doc(userID).get();
    DateTime okunanTarih = (okunanMap.data()["saat"]).toDate();
    return okunanTarih;
  }

  @override
  Future<List<MyUser.User>> getUserWithPagination(
      MyUser.User enSonGetirilenUser, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<MyUser.User> _tumKullanicilar = [];

    if (enSonGetirilenUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      MyUser.User _tekUser = MyUser.User.fromMap(snap.data());
      _tumKullanicilar.add(_tekUser);
    }

    return _tumKullanicilar;
  }

  Future<List<Mesaj>> getMessagesWithPagination(
      String currentUserID,
      String oppositeUserID,
      Mesaj enSonGetirilenMesaj,
      int sayfaBasinaGetirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Mesaj> _tumMesajlar = [];

    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await _firestoreDB
          .collection("konusmalar")
          .doc(currentUserID + "--" + oppositeUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .limit(sayfaBasinaGetirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await _firestoreDB
          .collection("konusmalar")
          .doc(currentUserID + "--" + oppositeUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(sayfaBasinaGetirilecekElemanSayisi)
          .get();
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Mesaj _tekMesaj = Mesaj.fromMap(snap.data());
      _tumMesajlar.add(_tekMesaj);
    }
    return _tumMesajlar;
  }

  @override
  Stream<List<Mesaj>> getMessages(String currentUserID, String oppositeUserID) {
    var snapShot = _firestoreDB
        .collection("konusmalar")
        .doc(currentUserID + "--" + oppositeUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  Future<String> tokenGetir(String kime) async {
    DocumentSnapshot snap = await _firestoreDB.doc("tokens/" + kime).get();
    if (snap != null) {
      return snap.data()["token"];
    }    else
      return null;
  }
}
