import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  final String konusmaSahibi;
  final String kimleKonusuyor;
  final bool goruldu;
  final Timestamp olusturulmaTarihi;
  final String sonMesaj;
  final Timestamp gorulmeTarihi;
  String konusulanUserName;
  String konusulanUserProfilURL;
  DateTime sonOkunmaZamani;

  String aradakiFark;

  Konusma(
      {this.konusmaSahibi,
      this.kimleKonusuyor,
      this.goruldu,
      this.olusturulmaTarihi,
      this.sonMesaj,
      this.gorulmeTarihi});

  Map<String, dynamic> toMap() {
    return {
      "konusma_sahibi": konusmaSahibi,
      "kimle_konusuyor": kimleKonusuyor,
      "goruldu": goruldu,
      "olusturulma_tarihi": olusturulmaTarihi ?? FieldValue.serverTimestamp(),
      "son_mesaj": sonMesaj ?? FieldValue.serverTimestamp(),
      "gorulme_tarihi": gorulmeTarihi
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : konusmaSahibi = map["konusma_sahibi"],
        kimleKonusuyor = map["kimle_konusuyor"],
        goruldu = map["goruldu"],
        olusturulmaTarihi = map["olusturulma_tarihi"],
        sonMesaj = map["son_mesaj"],
        gorulmeTarihi = map["gorulme_tarihi"];

  @override
  String toString() {
    return 'Konusma{konusmaSahibi: $konusmaSahibi, kimleKonusuyor: $kimleKonusuyor, goruldu: $goruldu, olusturulmaTarihi: $olusturulmaTarihi, sonMesaj: $sonMesaj, gorulmeTarihi: $gorulmeTarihi}';
  }
}
