import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_mesajlasma_uygulamasi/common_widget/social_login_buttons.dart';
import 'package:f_mesajlasma_uygulamasi/models/mesaj.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  String kisi;
  @override
  _ChatPageState createState() => _ChatPageState();
  ChatPage(String kisiisim){
    kisi=kisiisim;
  }
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollControllerListener);

  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _mesajController = TextEditingController();
    ChatViewModel _chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      backgroundColor: colorFromHex("F1F0E5"),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text(widget.kisi),
      ),
      body: _chatViewModel.state == ChatViewState.Busy
          ? _yeniElemanlarYukleniyorIndicator()
          : Center(
              child: Column(
                children: <Widget>[
                  _mesajListelemeAlani(),
                  _texInputAlani(_mesajController)
                ],
              ),
            ),
    );
  }

  Widget _mesajListelemeAlani() {
    return Consumer<ChatViewModel>(
      builder: (context, chatViewModel, child) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemCount: chatViewModel.hasMore
                ? chatViewModel.mesajlarListesi.length + 1
                : chatViewModel.mesajlarListesi.length,
            itemBuilder: (context, index) {
              if (chatViewModel.hasMore &&
                  chatViewModel.mesajlarListesi.length == index) {
                return _yeniElemanlarYukleniyorIndicator();
              }
              return _mesajBalonuOlustur(chatViewModel.mesajlarListesi[index]);
            },
          ),
        );
      },
    );
  }

  Widget _texInputAlani(TextEditingController _mesajController) {
    final _chatViewModel = Provider.of<ChatViewModel>(context);

    return Container(
      decoration: BoxDecoration(
        color: colorFromHex("#2C332F"),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600.withOpacity(0.8),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),

      padding: EdgeInsets.all(7),
      //color: Colors.grey,
      child: Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: new TextFormField(
              controller: _mesajController,
              decoration: new InputDecoration(contentPadding: EdgeInsets.all(8),
                hoverColor: Colors.white,
                filled: true,
                fillColor: Colors.grey.shade700.withOpacity(0.8),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(width: 1, color: Colors.white),
                ),
                hintText: "mesaj giriniz",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                decorationColor: Colors.black,
                //Font color change
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            height: 47,
            width: 70,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colorFromHex("EB200A"),
                  colorFromHex("E2243B"),
                  colorFromHex("D9286C"),
                  colorFromHex("CF2B9D"),
                  colorFromHex("C62FCE"),
                  colorFromHex("BD33FF"),
                ],
              ),
            ),
            child: MaterialButton(
              splashColor: colorFromHex("#8804F6"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.grey.shade100,
                size: 35,
              ),
              onPressed: () async {
                Mesaj _kaydedilecekMesaj;
                if (_mesajController.text.trim().length > 0) {
                  _kaydedilecekMesaj = Mesaj(
                      kimden: _chatViewModel.currentUser.userID,
                      kime: _chatViewModel.oppositeUser.userID,
                      bendenMi: true,
                      mesaj: _mesajController.text);
                  var sonuc = await _chatViewModel.saveMessage(
                      _kaydedilecekMesaj, _chatViewModel.currentUser);
                  if (sonuc == true) {
                    _mesajController.clear();
                  }
                  _scrollController.animateTo(
                    0,
                    curve: Curves.easeOut,
                    duration: Duration(milliseconds: 30),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _mesajBalonuOlustur(Mesaj oAnkiMesaj) {
    Color _gelenMesajRenk = colorFromHex("4C230A");
    Color _gidenMesajRenk = colorFromHex("F0FFCE");

    var _benimMesajimMi = oAnkiMesaj.bendenMi;
    var _saatdakika;

    try {
      _saatdakika = _saatDakikaGoster(oAnkiMesaj.date);
    } catch (e) {}

    if (_benimMesajimMi == true) {
      return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 320),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
                color: _gidenMesajRenk,
              ),
              child: Text(
                oAnkiMesaj.mesaj,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(3),
            ),
            Padding(
              padding: EdgeInsets.only(right: 7),
              child: Text(_saatdakika ?? " ",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700)),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 320),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
                color: _gelenMesajRenk,
              ),
              child: Text(
                oAnkiMesaj.mesaj,
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(3),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Text(
                _saatdakika ?? " ",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700),
              ),
            )
          ],
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisSaat = _formatter.format(date.toDate());
    return _formatlanmisSaat;
  }

  void _scrollControllerListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("\nscroll sonuna ulaştık");
      _eskiMesajlariGetir();
    }
  }

  void _eskiMesajlariGetir() async {
    if (!_isLoading) {
      _isLoading = true;
      final _chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
      await _chatViewModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
