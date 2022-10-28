import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;

import '../productDetailScreen.dart';

class ShopViewScreen extends StatefulWidget {
  final String shopId;
  final String image;
  final String name;
  const ShopViewScreen({Key key, this.shopId, this.name, this.image}) : super(key: key);

  @override
  State<ShopViewScreen> createState() => _ShopViewScreenState();
}

class _ShopViewScreenState extends State<ShopViewScreen> {

  List _shopCatList;
  List _shopProductList;
  var firstCatId;

  @override
  void initState() {
    super.initState();
    getCatData();
    getProductData();
  }

  Future<String> getCatData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"vendor_category/"+widget.shopId),);

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _shopCatList = dataConvertedToJSON['data'] ?? [];
        // firstCatId = _shopCatList[0]["catsid"]["image"];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }
  Future<String> getProductData() async {
    try {
      final response = await http.get(Uri.parse(global.baseUrl+"vendor_product/"+widget.shopId),);

      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        _shopProductList = dataConvertedToJSON['data'] ?? [];

      });
      return "Success";
    }  catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shopCatList == null ? Center(child: CircularProgressIndicator()) : _shopCatList.length == 0 ? Text("Category not found!") :
            Container(
              height: 85,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _shopCatList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 5, end: 5),
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 80,
                            padding: EdgeInsets.all(1),
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl: global.appInfo.imageUrl + _shopCatList[index]["catsid"]["image"],
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
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '${_shopCatList[index]["catsid"]["title"]}',
                              style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Products",style: TextStyle(fontSize: 18),),
            ),
            _shopProductList == null ? Center(child: CircularProgressIndicator()) : _shopProductList.length == 0 ? Text("Products not found!") :
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 215,
                  crossAxisCount: 2),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _shopProductList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 5, end: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            productId: _shopProductList[index]["product_id"],
                            shopId: widget.shopId,
                            // varientId: _shopProductList[index]["producvar"][0]["varient_id"],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            padding: EdgeInsets.all(1),
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl: global.appInfo.imageUrl + _shopProductList[index]["product_image"],
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
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '${_shopProductList[index]["product_name"]}',
                                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                    maxLines: 6,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Rs.'+_shopProductList[index]["producvar"][0]["base_mrp"].toString(),
                                      style: TextStyle(fontSize: 13,decoration:
                                      TextDecoration.lineThrough,fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                    ),
                                    SizedBox(width: 15,),
                                    Text(
                                      'Rs.'+_shopProductList[index]["producvar"][0]["base_price"].toString(),
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
