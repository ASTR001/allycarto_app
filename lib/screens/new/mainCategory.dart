import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/screens/new/subCategory.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;
import '../productListScreen.dart';
import 'package:gomeat/screens/productListScreen.dart';

class MainCategoryScreen extends BaseRoute {
  final String catId;
  final String name;

  MainCategoryScreen(this.catId, this.name, {a, o}) : super(a: a, o: o, r: 'SubcategoryListScreen');

  @override
  _SubcategoryListScreenState createState() => new _SubcategoryListScreenState(this.catId, this.name);
}

class _SubcategoryListScreenState extends BaseRouteState {

  List _shopList;

  String catId;
  String name;
  _SubcategoryListScreenState(this.catId, this.name) : super();

  @override
  void initState() {
    super.initState();
    getShopData();
  }

  Future<String> getShopData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"category/"+catId),);

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _shopList = dataConvertedToJSON['data'] ?? [];

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
      appBar: AppBar(title: Text(name),),
      body: _shopList == null ? Center(child: CircularProgressIndicator()) : _shopList.length == 0 ? Center(child: Text("No data found!"))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _shopList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:(MediaQuery.of(context).size.width / 3) / 125.0,
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubCategoryScreen( _shopList[i]["cat_id"].toString(), _shopList[i]["title"], a: widget.analytics, o: widget.observer),
                      ),
                    );
                  },
                  child: Container(
                    height: 172,
                    margin: EdgeInsets.only(top: 40, left: 10),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 172,
                          width: 140,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 78, left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_shopList[i]["title"]}',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -30,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: global.appInfo.imageUrl + _shopList[i]["image"],
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
                              height: 100,
                              width: 130,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
