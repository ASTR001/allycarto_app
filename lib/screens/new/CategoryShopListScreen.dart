import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

class ShopListScreen extends StatefulWidget {
  final String catId;
  final String name;

  const ShopListScreen({Key key, this.catId, this.name}) : super(key: key);

  @override
  State<ShopListScreen> createState() => _CategoryShopListScreenState();
}

class _CategoryShopListScreenState extends State<ShopListScreen> {

  List _shopList;
  var myPincodee;

  @override
  void initState() {
    super.initState();
    myPincodee = global.sp.getString('myPincode');
    if(myPincodee != null)
    getShopData();
  }

  Future<String> getShopData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"category_vendor?subcat_id="+widget.catId+"&pincode="+myPincodee),);


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
      appBar: AppBar(title: Text(widget.name),),
      body: _shopList == null ? Center(child: CircularProgressIndicator()) : _shopList.length == 0 ? Center(child: Text("No data found!"))
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
        itemCount: _shopList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:(MediaQuery.of(context).size.width / 3) / 125.0,
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
        itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Card(
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ShopViewScreen(image: global.appInfo.imageUrl + _shopList[index]["vuers"]["admin_image"], shopId : _shopList[index]["user_id"].toString(), name: _shopList[index]["shop_name"]),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: global.appInfo.imageUrl + _shopList[index]["vuers"]["admin_image"],
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
                          '${_shopList[index]["shop_name"]}',
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
    );
  }
}
