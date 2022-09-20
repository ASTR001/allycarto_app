import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

class TeamInfo extends StatefulWidget {
  const TeamInfo({Key key}) : super(key: key);

  @override
  State<TeamInfo> createState() => _FAQState();
}

class _FAQState extends State<TeamInfo> {

  List _myList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    try {
      final String globalId = global.currentUser.id.toString();
      final response = await http.get(Uri.parse(global.baseUrl+"myteam/"+globalId));

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
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("MyTeam"),),
        body: _myList == null
            ? Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        )
            : _myList.length == 0
            ? Center(
          child: Container(
            child: Text("Data Not Found!"),
          ),
        )
            : Container(
          margin: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          padding: EdgeInsets.only(top: 6),
          child: ListView.builder(
              itemCount: _myList.length,
              itemBuilder: (context, index) =>
                  Container(
                    margin: EdgeInsets.all(8),
                    child: Card(
                      child : Column(
                        children: [
                          Text(_myList[index]["name"],style: TextStyle(fontSize: 15),),
                          Text(_myList[index]["amount"],style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                  )),
        ));
  }
}
