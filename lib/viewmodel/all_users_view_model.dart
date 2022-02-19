import 'package:f_mesajlasma_uygulamasi/locator.dart';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:f_mesajlasma_uygulamasi/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUsersViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<MyUser.User> _tumKullanicilar;
  MyUser.User _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 10;
  UserRepository _userRepository = locator<UserRepository>();
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  AllUsersViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    print("\n\nstate değişti: " + _state.toString());
    notifyListeners();
  }

  List<MyUser.User> get kullanicilarListesi => _tumKullanicilar;

  getUserWithPagination(
      MyUser.User enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {
    if (_tumKullanicilar.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar.last;
    }

    if (yeniElemanlarGetiriliyor) {
    } else {
      state = AllUserViewState.Busy;
    }
    List<MyUser.User> yeniListe = await _userRepository.getUserWithPagination(
        _enSonGetirilenUser, sayfaBasinaGonderiSayisi);

    if (yeniListe.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    _tumKullanicilar.addAll(yeniListe);
    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {
    if (_hasMore) getUserWithPagination(_enSonGetirilenUser, true);
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    await getUserWithPagination(_enSonGetirilenUser, true);
    return Future.value(null);
  }
}
