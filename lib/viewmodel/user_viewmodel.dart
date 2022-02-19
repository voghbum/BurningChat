import 'dart:io';

import 'package:f_mesajlasma_uygulamasi/locator.dart';
import 'package:f_mesajlasma_uygulamasi/models/konusma.dart';
import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/repository/user_repository.dart';
import 'package:f_mesajlasma_uygulamasi/services/auth_base.dart';
import 'package:flutter/material.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  MyUser.User _user;
  String emailHataMesaji, sifreHataMesaji;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  MyUser.User get user => _user;

  UserViewModel() {
    currentUser();
  }

  @override
  Future<MyUser.User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser.User> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser.User> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null)
        return _user;
      else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser.User> createWithEmailandPassword(
      String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.createWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser.User> signInWithEmailandPassword(
      String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "Şifre en hata 6 karakter olmalı";
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    if (!email.contains("@")) {
      emailHataMesaji = "Geçersiz email";
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }
    return sonuc;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);

    return sonuc;
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var link = await _userRepository.uploadFile(userID, fileType, profilFoto);
    return link;
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String oppositeUserID) {
    return _userRepository.getMessages(currentUserID, oppositeUserID);
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    return await _userRepository.getAllConversations(userID);
  }

  getUserWithPagination(MyUser.User enSonGetirilenUser,
      int sayfadakiGetirilecekElemanSayisi) async {
    return await _userRepository.getUserWithPagination(
        enSonGetirilenUser, sayfadakiGetirilecekElemanSayisi);
  }
}
