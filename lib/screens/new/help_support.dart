import 'package:flutter/material.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({Key key}) : super(key: key);

  @override
  State<HelpSupport> createState() => _CoveragesState();
}

class _CoveragesState extends State<HelpSupport> {


  Column _getBackground () {
    return Column(
      children: [
        new Container(
          child: new Image.asset('assets/logo.jpg',
            fit: BoxFit.cover,
            height: 300.0,
          ),
          constraints: new BoxConstraints.expand(height: 300.0),
        ),
        Text("Help & Support",style: TextStyle(fontSize: 18,color: Colors.white),),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Content",style: TextStyle(fontSize: 14,color: Colors.white),),
            ),
          ],
        ),
      ],
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
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
          top: MediaQuery
              .of(context)
              .padding
              .top),
      child: new BackButton(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: new Color(0xFF736AB7),
        child: new Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            // _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }
}
