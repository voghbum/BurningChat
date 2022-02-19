import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createAt;
  DateTime updatedAt;
  int seviye;

  User({@required this.userID, this.email, this.profilURL});

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "email": email,
      "userName":
          userName ?? email.substring(0, email.indexOf("@")) + randomSayiUret(),
      "profilURL": profilURL ??
          "https://skyfiber.nl/wp-content/uploads/2020/02/black-profile-icon-illustration-user-profile-computer-icons-login-user-avatars-png-clip-art-thumbnail.png",
      "createAt": createAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "seviye": seviye ?? 1
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userID = map["userID"],
        email = map["email"],
        userName = map["userName"],
        profilURL = map["profilURL"],
        createAt = (map["createAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        seviye = map["seviye"];

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL , seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
