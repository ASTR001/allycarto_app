import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomeat/screens/new/CatModel.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

import 'faq.dart';

class FAQ_CAT extends StatefulWidget {
  const FAQ_CAT({Key key}) : super(key: key);

  @override
  State<FAQ_CAT> createState() => _FAQState();
}

class _FAQState extends State<FAQ_CAT> {

  List _myList;
  YoutubePlayerController _controller;
  var _cat;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<String> getData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"faqlist"));

      print("aaaaaaaaaaaaaa : "+global.baseUrl+"faqlist");

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Help & Support (FAQs)"),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 45,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: DropdownSearch<CatModel>(
          mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
          hint: "Select Category",
          onFind: (String filter) async {
            var response = await http.get(
              Uri.parse("https://allycarto.com/admin/api/faqcat"),
            );
            var dataConvertedToJSON = json.decode(response.body)["data"];
            var models = CatModel.fromJsonList(
                dataConvertedToJSON);
            return models;
          },
          onChanged: (CatModel data) {
            setState(() {
              _cat = data.id;
            });
          },
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.grey[400],
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.grey[500],
                )),
            hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.black38,
            ),
          ),
          showSearchBox: false,
          popupBackgroundColor: Colors.white,
          popupTitle: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          popupShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
        child: ElevatedButton(
          child: Text('SUBMIT'),
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              textStyle: TextStyle(
                  color: Colors.white)),
          onPressed: () {
            if(_cat == "") {
              showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please select category!');
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FAQ(cat_id: _cat),
                ),
              );
            }
          },
        ),
      ),
    ],
        )
    );
  }

  void showSnackBar({String snackBarMessage, Key key}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryTextTheme.headline5.color,
      key: key,
      content: Text(
        snackBarMessage,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
  }

}
