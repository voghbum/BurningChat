import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:http/http.dart' as http;

class BildirimGondermeSevice {
  Future<bool> bildirimGonder(
      Mesaj gonderilecekMesaj, MyUser.User gonderenUser, String token) async {
    String firebaseKey =
        "AAAA8-d_L5c:APA91bFIn5z3Zo_9qWPgmA2TstEyiKMvzwO0U4ijAlw5kjBLWqotMk405h0AJbrIy-QZNYcxvwKScGJGQV8AtKjPsIdLMEgPUba4YxHaQXejF2clYc5rLQItxt3IUJN2A4FL1hAE9ha2";
    String endURL = "https://fcm.googleapis.com/fcm/send";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };
    String json =
        '{ "to" : "$token","data" : {"message" : "${gonderilecekMesaj.mesaj}", "title" : "${gonderenUser.userName} yeni mesaj!", "gonderenUserID" : "${gonderenUser.userID}" , "gonderenUserName" : "${gonderenUser.userName}" }}';
    http.Response response =
        await http.post(endURL, headers: headers, body: json);
    if (response.statusCode == 200) {
      print("işlem başarılı");
    } else {
      print("işlem başarısız: " + response.statusCode.toString() + "\n");
      print("json: " + json);
    }
    return true;
  }
}
