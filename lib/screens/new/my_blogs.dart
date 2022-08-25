import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gomeat/screens/new/blog_list.dart';
import 'package:gomeat/screens/new/blog_view.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

class MyBlogs extends StatefulWidget {
  const MyBlogs({Key key}) : super(key: key);

  @override
  State<MyBlogs> createState() => _MyBlogsState();
}

class _MyBlogsState extends State<MyBlogs> {


  List _myList;
  List _myCatList;
  var myPincodee;

  @override
  void initState() {
    super.initState();
    myPincodee = global.sp.getString('myPincode');
    if(myPincodee != null)
      getCatData();
      getListData();
  }

  Future<String> getListData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"bloglist"));

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  Future<String> getCatData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"blogcategory"));

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _myCatList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(title: Text("My Blogs"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _myCatList == null ? Center(child: CircularProgressIndicator()) : _myCatList.length == 0 ? Center(child: Text("No data found!"))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _myCatList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:(MediaQuery.of(context).size.width / 1) / 85.0,
                    crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: new Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyBlogList(name: _myCatList[index]["cati_title"],id: _myCatList[index]["id"].toString()),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            '${_myCatList[index]["cati_title"]}',
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            _myList == null ? Center(child: Text("")) : _myList.length == 0 ? Center(child: Text("No data found!"))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _myList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:(MediaQuery.of(context).size.width / 3) / 125.0,
                    crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: new Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogViewScreen(title: _myList[index]["title"],image: _myList[index]["blog_image"],desc: _myList[index]["description"],tags: _myList[index]["tags"],),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: global.appInfo.imageUrl + _myList[index]["blog_image"],
                                imageBuilder: (context, imageProvider) => Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: AssetImage('${global.defaultImage}'), fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                '${_myList[index]["title"]}',
                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
