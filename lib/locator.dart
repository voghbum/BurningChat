import 'package:f_mesajlasma_uygulamasi/repository/user_repository.dart';
import 'package:f_mesajlasma_uygulamasi/services/bildirim_gonderme_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/fake_auth_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/firebase_auth_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/firebase_storage_service.dart';
import 'package:f_mesajlasma_uygulamasi/services/firestore_db_service.dart';
import "package:get_it/get_it.dart";

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => BildirimGondermeSevice());
}
