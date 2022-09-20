import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomeat/screens/new/WebViewScreen.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

class MyTeam extends StatefulWidget {
  const MyTeam({Key key}) : super(key: key);

  @override
  State<MyTeam> createState() => _FAQState();
}

class _FAQState extends State<MyTeam> {

  List _myList;
  bool downsts = false;
  String globalId;

  @override
  void initState() {
    globalId = global.currentUser.id.toString();
    super.initState();
    getData();
  }

  Future<String> getData() async {
    try {
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
        appBar: AppBar(title: Text("My Team - Direct Downline"),),
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
                    margin: EdgeInsets.all(12),
                    child: Card(
                      color: Colors.red[50],
                      child : Padding(
                        padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                        child: Column(
                          children: [
                            SizedBox(height: 7,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WebViewScreen(custid: globalId, mlmid: _myList[index]["id"].toString()),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person),
                                      SizedBox(width: 7,),
                                      Text(_myList[index]["name"],style: TextStyle(fontSize: 15),),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      downsts = !downsts;
                                    });
                                  },
                                    child: Icon(Icons.arrow_drop_down)),
                              ],
                            ),
                            downsts == true ? Text(_myList[index]["amount"],style: TextStyle(fontSize: 18),) : SizedBox.shrink(),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  )),
        ));
  }
}
