import 'package:f_mesajlasma_uygulamasi/models/konusma.dart';
import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;

abstract class DBBase {
  Future<bool> saveUser(MyUser.User user);

  Future<MyUser.User> readUser(String userID);

  Future<bool> updateUserName(String userID, String yeniUserName);

  Future<bool> updateProfilPhoto(String userID, String profilFotoUrl);


  Future<List<Konusma>> getAllConversations(String userID);

  Stream<List<Mesaj>> getMessages(String currentUserID, String oppositeUserID);

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);

  Future<DateTime> saatiGoster(String userID);

  Future<List<MyUser.User>> getUserWithPagination(MyUser.User enSonGetirilenUser , int getirilecekElemanSayisi);
}
