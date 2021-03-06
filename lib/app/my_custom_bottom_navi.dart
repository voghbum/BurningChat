import 'package:f_mesajlasma_uygulamasi/app/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigation extends StatefulWidget {
  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu,
      @required this.navigatorKeys})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  _MyCustomBottomNavigationState createState() =>
      _MyCustomBottomNavigationState();
}

class _MyCustomBottomNavigationState extends State<MyCustomBottomNavigation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                  onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
                  items: [
                    _navItemOlustur(TabItem.Kullanicilar),
                    _navItemOlustur(TabItem.Konusmalarim),
                    _navItemOlustur(TabItem.Profil),
                  ]),
              tabBuilder: (context, index) {
                final gosterilecekItem = TabItem.values[index];
                return CupertinoTabView(
                    navigatorKey: widget.navigatorKeys[gosterilecekItem],
                    builder: (context) {
                      return widget.sayfaOlusturucu[gosterilecekItem];
                    });
              }),
        ),
      ],
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(olusturulacakTab.icon),
      label: olusturulacakTab.title,
    );
  }
}
