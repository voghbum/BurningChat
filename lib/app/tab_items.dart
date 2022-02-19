import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Konusmalarim, Profil }

class TabItemData {
  TabItemData(this.title, this.icon);

  final String title;
  final IconData icon;

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar : TabItemData("Kullanıcılar", Icons.people),
    TabItem.Konusmalarim : TabItemData("Konuşmalarım", Icons.chat),
    TabItem.Profil : TabItemData("Profil", Icons.account_circle)
  };
}
