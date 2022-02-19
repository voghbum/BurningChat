import 'dart:async';
import 'package:f_mesajlasma_uygulamasi/locator.dart';
import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;

enum ChatViewState { Idle, Busy, Loaded }

class ChatViewModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  final MyUser.User currentUser;
  final MyUser.User oppositeUser;
  static final sayfaBasinaGonderiSayisi = 14;
  UserRepository _userRepository = locator<UserRepository>();
  Mesaj _enSonGetirilenMesaj;
  Mesaj _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _newMessageListener = false;
  StreamSubscription _streamSubscription;

  ChatViewModel({this.currentUser, this.oppositeUser}) {
    _tumMesajlar = [];
    getMessagesWithPagination(false);
  }

  bool get hasMore => _hasMore;

  List<Mesaj> get mesajlarListesi => _tumMesajlar;

  set state(value) {
    _state = value;
    notifyListeners();
  }

  ChatViewState get state => _state;

  @override
  dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, MyUser.User currentUser) {
    return _userRepository.saveMessage(kaydedilecekMesaj,currentUser);
  }

  void getMessagesWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_tumMesajlar.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
    }
    if (!yeniMesajlarGetiriliyor) state = ChatViewState.Busy;

    List<Mesaj> getirilenMesajlar =
        await _userRepository.getMessagesWithPagination(
            currentUser.userID,
            oppositeUser.userID,
            _enSonGetirilenMesaj,
            sayfaBasinaGonderiSayisi);

    if (getirilenMesajlar.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    _tumMesajlar.addAll(getirilenMesajlar);
    if (_tumMesajlar.length > 0) _listeyeEklenenIlkMesaj = _tumMesajlar.first;

    state = ChatViewState.Loaded;
    if (_newMessageListener == false) {
      _newMessageListener = true;
      initNewMessageListener();
    }
  }

  Future<void> dahaFazlaMesajGetir() async {
    if (_hasMore) getMessagesWithPagination(true);
  }

  void initNewMessageListener() {
    print("ListenerAta");
    _streamSubscription = _userRepository
        .getMessages(currentUser.userID, oppositeUser.userID)
        .listen((anlikData) {
      if (anlikData.isNotEmpty) {
        if (anlikData[0].date != null) {
          if (_listeyeEklenenIlkMesaj == null) {
            _tumMesajlar.insert(0, anlikData[0]);
          } else if (_listeyeEklenenIlkMesaj.date.millisecondsSinceEpoch !=
              anlikData[0].date.millisecondsSinceEpoch)
            _tumMesajlar.insert(0, anlikData[0]);
        }
        state = ChatViewState.Loaded;
      }
    });
  }
}
