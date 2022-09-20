import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

class Coverages extends StatefulWidget {
  const Coverages({Key key}) : super(key: key);

  @override
  State<Coverages> createState() => _CoveragesState();
}

class _CoveragesState extends State<Coverages> {

  List _myList;

  @override
  void initState() {
    super.initState();

      getData();
  }

  Future<String> getData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"coveragelist"));

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
         _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }


  Column _getBackground () {
        return Column(
          children: [
            new Container(
                        child: new Image.asset('assets/logo.jpg',
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 200,
                        ),
                    constraints: new BoxConstraints.expand(height: 200.0, width: 200),
                  ),
            SizedBox(height: 15,),
            Text("Ally Carto Coverage",style: TextStyle(fontSize: 18,color: Colors.red),),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Html(
                data: _myList[0]["contents"],
                style: {
                  "body": Style(color: Theme.of(context).primaryTextTheme.bodyText1.color),
                },
              ),
            ),
          ],
        );
      }

  Container _getGradient() {
        return new Container(
              margin: new EdgeInsets.only(top: 90.0),
          height: 110.0,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: <Color>[
                new Color(0x00736AB7),
                new Color(0xFF736AB7)
              ],
              stops: [0.0, 0.9],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
            ),
          ),
        );
      }

  Container _getToolbar(BuildContext context) {
        return new Container(
                    margin: new EdgeInsets.only(
                    top: 10),
                child: new BackButton(color: Colors.black87),
              );
      }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
                body: _myList == null ? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
                  child: new Container(
              // constraints: new BoxConstraints.expand(),
              color:  Colors.white,
              child: new Stack (
                  children: <Widget>[
                    _getBackground(),
                    // _getGradient(),
                    // _getContent(),
                    _getToolbar(context),
                  ],
              ),
            ),
                ),
          ),
    );
  }
}
