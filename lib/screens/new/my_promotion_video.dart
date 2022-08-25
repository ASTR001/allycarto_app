import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class MyPromotionVideos extends StatefulWidget {
  const MyPromotionVideos({Key key}) : super(key: key);

  @override
  State<MyPromotionVideos> createState() => _MyPromotionVideosState();
}

class _MyPromotionVideosState extends State<MyPromotionVideos> {


  List _myList;
  var myPincodee;
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    myPincodee = global.sp.getString('myPincode');
    if(myPincodee != null)
      getShopData();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<String> getShopData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"promo_video"));


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
        appBar: AppBar(title: Text("Promotion Videos"),),
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
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(8),
                child: YoutubePlayerControllerProvider(
                  controller:
                  _controller = YoutubePlayerController(
                    initialVideoId: YoutubePlayerController
                        .convertUrlToId(_myList[index]
                    ["video"]), // livestream example
                    params: YoutubePlayerParams(
                      //startAt: Duration(minutes: 1, seconds: 5),
                      showControls: true,
                      showFullscreenButton: true,
                      desktopMode:
                      false, // false for platform design
                      autoPlay: false,
                      enableCaption: false,
                      showVideoAnnotations: false,
                      enableJavaScript: false,
                      privacyEnhanced: false,
                      strictRelatedVideos: true,
                      loop: false,
                      playsInline:
                      false, // iOS only - Auto fullscreen or not
                    ),
                  )..listen((value) {
                    if (value.isReady && !value.hasPlayed) {
                      _controller
                        ..hidePauseOverlay()
                      // Uncomment below to start autoplay on iOS
                      //..play()
                        ..hideTopMenu();
                    }
                  }),
                  child: YoutubePlayerIFrame(
                    aspectRatio: 16 / 9,
                  ),
                ),
              )),
        ));
  }
}
