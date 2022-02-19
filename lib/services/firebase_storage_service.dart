import 'dart:io';
import 'package:f_mesajlasma_uygulamasi/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File willuploadFile) async {
    _storageReference = _firebaseStorage.ref().child(userID).child(fileType).child("profil_foto.png");
    var uploadTask = _storageReference.putFile(willuploadFile);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print("\n!!!!!\nfirebaseStorage/uploadFile url: " + url + "\n");
    return url;
  }
}
