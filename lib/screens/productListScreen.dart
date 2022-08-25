import 'package:badges/badges.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:gomeat/models/businessLayer/baseRoute.dart';

import 'package:gomeat/models/businessLayer/global.dart' as global;

import 'package:gomeat/models/productFilterModel.dart';

import 'package:gomeat/models/productModel.dart';

import 'package:gomeat/screens/checkOutScreen.dart';

import 'package:gomeat/screens/filterScreen.dart';
import 'package:gomeat/screens/new/CategoryShopListScreen.dart';

import 'package:gomeat/screens/productDetailScreen.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:shimmer/shimmer.dart';



import 'loginScreen.dart';



class ProductListScreen extends BaseRoute {

  final int subcategoryId;

  final int screenId;

  final String title;
  final String mainCatId;

  ProductListScreen(this.screenId, this.title, this.mainCatId, {this.subcategoryId, a, o}) : super(a: a, o: o, r: 'ProductListScreen');

  @override

  _ProductListScreenState createState() => new _ProductListScreenState(this.screenId, this.title, this.mainCatId, this.subcategoryId);

}



class _ProductListScreenState extends BaseRouteState {

  bool _isRecordPending = true;

  bool _isMoreDataLoaded = false;

  ProductFilter _productFilter = new ProductFilter();

  ScrollController _scrollController = ScrollController();

  bool _isDataLoaded = false;

  TextEditingController searchController = new TextEditingController();

  List<Product> _productList = [];

  int page = 1;

  int subcategoryId;

  String mainCatId;

  int screenId;

  GlobalKey<ScaffoldState> _scaffoldKey;

  String title;


  bool variantIndexx = true;

  bool variantIndexStatus = true;

  _ProductListScreenState(this.screenId, this.title, this.mainCatId, this.subcategoryId) : super();



  @override

  Widget build(BuildContext context) {

    return SafeArea(

      child: Scaffold(

        appBar: AppBar(

          centerTitle: true,

          leading: InkWell(

            customBorder: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(30),

            ),

            onTap: () {

              Navigator.of(context).pop();

            },

            child: Align(

              alignment: Alignment.center,

              child: Icon(MdiIcons.arrowLeft),

            ),

          ),

          title: Text(title),

          actions: [


            global.currentUser.cartCount != null && global.currentUser.cartCount > 0

                ? FloatingActionButton(

              elevation: 0,

              backgroundColor: Colors.transparent,

              heroTag: null,

              child: Badge(

                badgeContent: Text(

                  "${global.currentUser.cartCount}",

                  style: TextStyle(color: Colors.white, fontSize: 08),

                ),

                padding: EdgeInsets.all(6),

                badgeColor: Colors.red,

                child: Icon(

                  MdiIcons.shoppingOutline,

                  color: Theme.of(context).appBarTheme.actionsIconTheme.color,

                ),

              ),

              mini: true,

              onPressed: () {

                Navigator.of(context).push(

                  MaterialPageRoute(

                    builder: (context) => CheckoutScreen(a: widget.analytics, o: widget.observer),

                  ),

                );

              },

            )

                : FloatingActionButton(

              elevation: 0,

              backgroundColor: Colors.transparent,

              heroTag: null,

              child: Icon(

                MdiIcons.shoppingOutline,

                color: Theme.of(context).appBarTheme.actionsIconTheme.color,

              ),

              mini: true,

              onPressed: () {

                Navigator.of(context).push(

                  MaterialPageRoute(

                    builder: (context) => CheckoutScreen(a: widget.analytics, o: widget.observer),

                  ),

                );

              },

            ),

            // IconButton(
            //
            //   onPressed: () {
            //
            //     Navigator.of(context)
            //
            //         .push(
            //
            //       MaterialPageRoute(
            //
            //         builder: (context) => FilterScreen(_productFilter, a: widget.analytics, o: widget.observer),
            //
            //       ),
            //
            //     )
            //
            //         .then((value) async {
            //
            //       if (value != null) {
            //
            //         _isDataLoaded = false;
            //
            //         _isRecordPending = true;
            //
            //         _productList.clear();
            //
            //         setState(() {});
            //
            //         _productFilter = value;
            //
            //         print("screen id $screenId");
            //
            //         await _init();
            //
            //       }
            //
            //     });
            //
            //   },
            //
            //   icon: Icon(
            //
            //     MdiIcons.tuneVerticalVariant,
            //
            //     color: Theme.of(context).appBarTheme.actionsIconTheme.color,
            //
            //   ),
            //
            // )

          ],

        ),

        body: Padding(

          padding: EdgeInsets.all(10.0),

          child: RefreshIndicator(

            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            color: Theme.of(context).primaryColor,

            onRefresh: () async {

              _isDataLoaded = false;

              _isRecordPending = true;

              setState(() {});

              _productList.clear();

              await _init();

              return null;

            },

            child: _isDataLoaded

                ? _productList.isNotEmpty

                ? SingleChildScrollView(

              controller: _scrollController,

              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10, bottom: 12),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: TextField(
                                controller: searchController,
                                style: Theme.of(context).primaryTextTheme.bodyText1,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                                    prefixIcon: Icon(Icons.search,color: Colors.grey,),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _init();
                                        searchController.clear();
                                      },
                                      icon: Icon(Icons.clear,color: Colors.grey,size: 20,),
                                    ),
                                    hintText: 'Search here...',
                                    border: InputBorder.none),
                                onSubmitted: (val) {
                                  // setState(() {
                                  //   _productList = _productList
                                  //       .where((u) => (u.productName
                                  //       .toLowerCase()
                                  //       .contains(val.toLowerCase())))
                                  //       .toList();
                                  // });
                                  _getCatSearchedProduct(val);
                                },
                                // onChanged: (val) {
                                //   setState(() {
                                //     _productList = _productList
                                //         .where((u) => (u.productName
                                //         .toLowerCase()
                                //         .contains(val.toLowerCase())))
                                //         .toList();
                                //   });
                                // },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ShopListScreen(catId : subcategoryId.toString(), name : title),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0,right: 0, bottom: 12),
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.indigo[300], borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text("Get it Local", style: TextStyle(fontSize: 11),),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  ListView.builder(

                    physics: ScrollPhysics(),

                    itemCount: _productList.length,

                    shrinkWrap: true,

                    itemBuilder: (BuildContext context,int index) {


                      if(variantIndexx) {
                        _productList[index].selectVarient = (_productList[index]
                            .varientId).toString();
                      }


                      return Container(

                        margin: EdgeInsets.only(top: 10, bottom: 10),

                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(

                            Radius.circular(10),

                          ),

                        ),

                        child: InkWell(

                          onTap: () {

                            Navigator.of(context).push(

                              MaterialPageRoute(

                                builder: (context) => ProductDetailScreen(productId: _productList[index].productId, a: widget.analytics, o: widget.observer),

                              ),

                            );

                          },

                          borderRadius: BorderRadius.all(

                            Radius.circular(10),

                          ),

                          child: Stack(

                            clipBehavior: Clip.none,

                            alignment: Alignment.center,

                            children: [

                              Container(

                                height: 160,

                                width: MediaQuery.of(context).size.width,

                                child: Container(

                                  decoration: BoxDecoration(

                                    color: Theme.of(context).cardTheme.color,

                                    borderRadius: BorderRadius.all(

                                      Radius.circular(10),

                                    ),

                                  ),

                                  child: Padding(

                                    padding: const EdgeInsets.only(top: 18, left: 130),

                                    child: Column(

                                      // mainAxisSize: MainAxisSize.min,

                                      mainAxisAlignment: MainAxisAlignment.start,

                                      crossAxisAlignment: global.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,

                                      children: [

                                        SizedBox(height: 5,),

                                        Text(

                                            '${_productList[index].productName}',

                                            style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500),
                                            maxLines: 2,

                                            // overflow: TextOverflow.ellipsis,

                                          ),

                                        // Text(
                                        //
                                        //   '${_productList[index].type}',
                                        //
                                        //   style: Theme.of(context).primaryTextTheme.headline2,
                                        //
                                        //   overflow: TextOverflow.ellipsis,
                                        //
                                        // ),

                                        SizedBox(height: 3,),

                                        RichText(

                                          text: TextSpan(

                                            text: "${global.appInfo.currencySign} ",

                                            style: Theme.of(context).primaryTextTheme.headline2,

                                            children: [

                                              TextSpan(

                                                text: '${_productList[index].price}',

                                                style: Theme.of(context).primaryTextTheme.bodyText1,

                                              ),

                                              TextSpan(

                                                text: ' / ${_productList[index].quantity} ${_productList[index].unit}',

                                                style: Theme.of(context).primaryTextTheme.headline2,

                                              )

                                            ],

                                          ),

                                        ),

                                        SizedBox(height: 3,),

                                        _productList[index].rating != null && _productList[index].rating > 0

                                            ? Padding(

                                          padding: EdgeInsets.only(top: 4.0),

                                          child: Row(

                                            mainAxisSize: MainAxisSize.min,

                                            mainAxisAlignment: MainAxisAlignment.start,

                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: [

                                              Icon(

                                                Icons.star,

                                                size: 18,

                                                color: Theme.of(context).primaryColorLight,

                                              ),

                                              RichText(

                                                text: TextSpan(

                                                  text: "${_productList[index].rating} ",

                                                  style: Theme.of(context).primaryTextTheme.bodyText1,

                                                  children: [

                                                    TextSpan(

                                                      text: '|',

                                                      style: Theme.of(context).primaryTextTheme.headline2,

                                                    ),

                                                    TextSpan(

                                                      text: ' ${_productList[index].ratingCount} ${AppLocalizations.of(context).txt_ratings}',

                                                      style: Theme.of(context).primaryTextTheme.headline1,

                                                    )

                                                  ],

                                                ),

                                              ),

                                            ],

                                          ),

                                        )

                                            : SizedBox(),





                                        Padding(

                                          padding: const EdgeInsets.only(right: 12.0,top: 3,bottom: 0),

                                          child: Container(

                                            height: 35,

                                            width: MediaQuery.of(context).size.width,

                                            child: DropdownButtonFormField<String>(//

                                              decoration: InputDecoration(

                                                fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _productList[index].varient.length > 1 ?Colors.green : Colors.grey,)),

                                                contentPadding: EdgeInsets.only(top: 2, left: 5, right: 5),

                                              ),

                                              dropdownColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,// Not necessary for Option 1

                                              icon: Padding(

                                                padding: const EdgeInsets.only(right: 10),

                                                child: Icon(

                                                  Icons.expand_more,

                                                  color: Theme.of(context).iconTheme.color,

                                                ),

                                              ),

                                              style: TextStyle(fontSize: 7),

                                              value: _productList[index].selectVarient + "," + _productList[index].price.toString() != null? _productList[index].selectVarient + "," + _productList[index].price.toString() : null,

                                              onChanged: (String newValue) {

                                                setState(() {

                                                  final split = newValue.split(',');

                                                  variantIndexx = false;
                                                  variantIndexStatus = false;

                                                  _productList[index].selectVarient = split[0];
                                                  _productList[index].dropdownIndexStatus = false;
                                                  _productList[index].varient[0].cartQty = 0;

                                                  _productList[index].price = int.parse(split[1]);

                                                });

                                              },
                                              isExpanded: true,

                                              items: _productList[index].varient.map((variantt) {

                                                return DropdownMenuItem<String>(

                                                  value: variantt.varientId.toString() + "," + variantt.price.toString(),

                                                  child: new Text(

                                                    variantt.description.toString(),
                                                    overflow: TextOverflow.ellipsis,

                                                    // softWrap: true,

                                                    style: const TextStyle(

                                                      fontSize: 11,

                                                      color: Colors.black87,

                                                    ),

                                                  ),

                                                );

                                              }).toList(),

                                            ),

                                          ),

                                        ),

                                        SizedBox(height: 7,),



                                      ],

                                    ),

                                  ),

                                ),

                              ),



                              Positioned(

                                right: 0,

                                top: 0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () async {

                                          bool _isAdded = await addRemoveWishList(_productList[index].storeId.toString(),_productList[index].varientId, _scaffoldKey);

                                          if (_isAdded) {

                                            _productList[index].isFavourite = !_productList[index].isFavourite;

                                          }



                                          setState(() {});

                                        },

                                        icon: _productList[index].isFavourite

                                            ? Icon(

                                          MdiIcons.heart,

                                          size: 17,

                                          color: Color(0xFFEF5656),

                                        )

                                            : Icon(

                                          MdiIcons.heart,

                                          size: 17,

                                          color: Color(0xFF4A4352),

                                        ),

                                      ),
                                    ),
                                    _productList[index].discount != null && _productList[index].discount > 0

                                        ? Container(

                                      height: 22,

                                      width: 70,

                                      decoration: BoxDecoration(

                                        color: Colors.green,

                                        borderRadius: BorderRadius.only(

                                          topRight: Radius.circular(10),

                                          bottomLeft: Radius.circular(10),

                                        ),

                                      ),

                                      child: Text(

                                        "${_productList[index].discount}% ${AppLocalizations.of(context).txt_off}",

                                        textAlign: TextAlign.center,

                                        style: Theme.of(context).primaryTextTheme.caption,

                                      ),

                                    )

                                        : SizedBox(

                                      height: 22,

                                      width: 60,

                                    ),
                                  ],
                                ),
                              ),



                              // add cart start



                              _productList[index].stock > 0

                                  ? Positioned(

                                  bottom: 0,

                                  right: 0,

                                  child:  _productList[index].varient[0].cartQty == null ||

                                      (_productList[index].varient[0].cartQty != null && _productList[index].varient[0].cartQty == 0)

                                      ? Container(

                                    height: 30,

                                    width: 60,

                                    decoration: BoxDecoration(

                                      color: Colors.orange,
                                      // color: Theme.of(context).iconTheme.color,

                                      borderRadius: BorderRadius.only(

                                        bottomRight: Radius.circular(10),

                                        topLeft: Radius.circular(10),

                                      ),

                                    ),

                                    child: FlatButton(
                                      child: Text('ADD',style: TextStyle(color: Colors.white),),

                                      padding: EdgeInsets.all(0),

                                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),

                                      onPressed: () async {

                                        if (global.currentUser.id == null) {

                                          Future.delayed(Duration.zero, () {

                                            Navigator.of(context).push(

                                              MaterialPageRoute(

                                                  builder: (context) => LoginScreen(

                                                    a: widget.analytics,

                                                    o: widget.observer,

                                                  )),

                                            );

                                          });

                                        } else {

                                          setState(() {
                                            _productList[index].varient[0].cartQty = 1;
                                          });

                                          bool isAdded = await addToCart(_productList[index].storeId.toString(),1, variantIndexStatus ? _productList[index].varientId : int.parse(_productList[index].selectVarient), 0, _scaffoldKey, true);

                                          if (isAdded) {

                                            setState(() {
                                              _productList[index].varient[0].cartQty = 1;
                                              // _productList[index].varient[0].cartQty = _productList[index].varient[0].cartQty + 1;
                                            });

                                          }


                                        }

                                      },

                                      // icon: Icon(
                                      //
                                      //   Icons.done_outline_outlined,
                                      //
                                      //   color: Theme.of(context).primaryTextTheme.caption.color,
                                      //
                                      // ),

                                    ),

                                  )

                                      : Container(

                                    height: 28,

                                    width: 80,

                                    decoration: BoxDecoration(

                                      gradient: LinearGradient(

                                        stops: [0, .90],

                                        begin: Alignment.centerLeft,

                                        end: Alignment.centerRight,

                                        colors: [Color(0xFFe03337), Color(0xFFb73537)],

                                      ),

                                      borderRadius: BorderRadius.only(

                                        bottomRight: Radius.circular(10),

                                        topLeft: Radius.circular(10),

                                      ),

                                    ),

                                    child: Row(

                                      mainAxisSize: MainAxisSize.min,

                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [

                                        IconButton(

                                            padding: EdgeInsets.all(0),

                                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),

                                            onPressed: () async {


                                              bool isAdded = await addToCart(_productList[index].storeId.toString(),_productList[index].varient[0].cartQty - 1,

                                                  variantIndexStatus ? _productList[index].varientId : int.parse(_productList[index].selectVarient), 0, _scaffoldKey, false);

                                              if (isAdded) {

                                                _productList[index].varient[0].cartQty = _productList[index].varient[0].cartQty - 1;

                                              }

                                              setState(() {});

                                            },

                                            icon: Icon(

                                              FontAwesomeIcons.minus,

                                              size: 11,

                                              color: Theme.of(context).primaryTextTheme.caption.color,

                                            )),

                                        Text(

                                          "${_productList[index].varient[0].cartQty}",

                                          style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(color: Theme.of(context).primaryTextTheme.caption.color),

                                        ),

                                        IconButton(

                                            padding: EdgeInsets.all(0),

                                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),

                                            onPressed: () async {

                                              print("aaaabbbb001 : "+_productList[index].selectVarient);


                                              bool isAdded = await addToCart(_productList[index].storeId.toString(),_productList[index].varient[0].cartQty + 1,

                                                  variantIndexStatus ? _productList[index].varientId : int.parse(_productList[index].selectVarient), 0, _scaffoldKey, false);

                                              if (isAdded) {

                                                _productList[index].varient[0].cartQty = _productList[index].varient[0].cartQty + 1;

                                              }

                                              setState(() {});

                                            },

                                            icon: Icon(

                                              FontAwesomeIcons.plus,

                                              size: 11,

                                              color: Theme.of(context).primaryTextTheme.caption.color,

                                            )),

                                      ],

                                    ),

                                  )



                              ) : SizedBox() ,



                              // _productList[index].stock > 0
                              //
                              //     ? Positioned(
                              //
                              //     bottom: 0,
                              //
                              //     right: 0,
                              //
                              //     child:  _productList[index].varient[0].cartQty == null ||
                              //
                              //         (_productList[index].varient[0].cartQty != null && _productList[index].varient[0].cartQty == 0)
                              //
                              //         ? Container(
                              //
                              //       height: 30,
                              //
                              //       width: 30,
                              //
                              //       decoration: BoxDecoration(
                              //
                              //         color: Theme.of(context).iconTheme.color,
                              //
                              //         borderRadius: BorderRadius.only(
                              //
                              //           bottomRight: Radius.circular(10),
                              //
                              //           topLeft: Radius.circular(10),
                              //
                              //         ),
                              //
                              //       ),
                              //
                              //       child: IconButton(
                              //
                              //         padding: EdgeInsets.all(0),
                              //
                              //         visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              //
                              //         onPressed: () async {
                              //
                              //           if (global.currentUser.id == null) {
                              //
                              //             Future.delayed(Duration.zero, () {
                              //
                              //               Navigator.of(context).push(
                              //
                              //                 MaterialPageRoute(
                              //
                              //                     builder: (context) => LoginScreen(
                              //
                              //                       a: widget.analytics,
                              //
                              //                       o: widget.observer,
                              //
                              //                     )),
                              //
                              //               );
                              //
                              //             });
                              //
                              //           } else {
                              //
                              //             print("aaaabbbb001 : "+_productList[index].selectVarient);
                              //
                              //             bool isAdded = await addToCart(1, variantIndexStatus ? _productList[index].varientId : int.parse(_productList[index].selectVarient), 0, _scaffoldKey, true);
                              //
                              //             if (isAdded) {
                              //
                              //               _productList[index].varient[0].cartQty = _productList[index].varient[0].cartQty + 1;
                              //
                              //             }
                              //
                              //             setState(() {});
                              //
                              //           }
                              //
                              //         },
                              //
                              //         icon: Icon(
                              //
                              //           Icons.add,
                              //
                              //           color: Theme.of(context).primaryTextTheme.caption.color,
                              //
                              //         ),
                              //
                              //       ),
                              //
                              //     )
                              //
                              //         : Container(
                              //
                              //       height: 28,
                              //
                              //       width: 80,
                              //
                              //       decoration: BoxDecoration(
                              //
                              //         gradient: LinearGradient(
                              //
                              //           stops: [0, .90],
                              //
                              //           begin: Alignment.centerLeft,
                              //
                              //           end: Alignment.centerRight,
                              //
                              //           colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                              //
                              //         ),
                              //
                              //         borderRadius: BorderRadius.only(
                              //
                              //           bottomRight: Radius.circular(10),
                              //
                              //           topLeft: Radius.circular(10),
                              //
                              //         ),
                              //
                              //       ),
                              //
                              //       child: Row(
                              //
                              //         mainAxisSize: MainAxisSize.min,
                              //
                              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //
                              //         crossAxisAlignment: CrossAxisAlignment.center,
                              //
                              //         children: [
                              //
                              //           IconButton(
                              //
                              //               padding: EdgeInsets.all(0),
                              //
                              //               visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              //
                              //               onPressed: () async {
                              //
                              //                 print("aaaabbbb001 : "+_productList[index].selectVarient);
                              //
                              //
                              //                 bool isAdded = await addToCart(_productList[index].varient[0].cartQty - 1,
                              //
                              //                     variantIndexStatus ? _productList[index].varientId : int.parse(_productList[index].selectVarient), 0, _scaffoldKey, false);
                              //
                              //                 if (isAdded) {
                              //
                              //                   _productList[index].varient[0].cartQty = _productList[index].varient[0].cartQty - 1;
                              //
                              //                 }
                              //
                              //                 setState(() {});
                              //
                              //               },
                              //
                              //               icon: Icon(
                              //
                              //                 FontAwesomeIcons.minus,
                              //
                              //                 size: 11,
                              //
                              //                 color: Theme.of(context).primaryTextTheme.caption.color,
                              //
                              //               )),
                              //
                              //           Text(
                              //
                              //             "${_productList[index].varient[0].cartQty}",
                              //
                              //             style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(color: Theme.of(context).primaryTextTheme.caption.color),
                              //
                              //           ),
                              //
                              //           IconButton(
                              //
                              //               padding: EdgeInsets.all(0),
                              //
                              //               visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              //
                              //               onPressed: () async {
                              //
                              //                 print("aaaabbbb001 : "+_productList[index].selectVarient);
                              //
                              //
                              //                 bool isAdded = await addToCart(_productList[index].varient[0].cartQty + 1,
                              //
                              //                     variantIndexStatus ? _productList[index].varientId : int.parse(_productList[index].selectVarient), 0, _scaffoldKey, false);
                              //
                              //                 if (isAdded) {
                              //
                              //                   _productList[index].varient[0].cartQty = _productList[index].varient[0].cartQty + 1;
                              //
                              //                 }
                              //
                              //                 setState(() {});
                              //
                              //               },
                              //
                              //               icon: Icon(
                              //
                              //                 FontAwesomeIcons.plus,
                              //
                              //                 size: 11,
                              //
                              //                 color: Theme.of(context).primaryTextTheme.caption.color,
                              //
                              //               )),
                              //
                              //         ],
                              //
                              //       ),
                              //
                              //     )
                              //
                              //
                              //
                              // ) : SizedBox(),



                              // add cart end



                              Positioned(

                                left: 0,

                                top: -10,

                                child: Column(
                                  children: [
                                    Container(

                                      padding: const EdgeInsets.only(left: 6),

                                      child: CachedNetworkImage(

                                        imageUrl: global.appInfo.imageUrl + _productList[index].productImage,

                                        imageBuilder: (context, imageProvider) => Container(

                                          decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(15),

                                            image: DecorationImage(

                                              image: imageProvider,

                                              fit: BoxFit.cover,

                                            ),

                                          ),

                                          alignment: Alignment.center,

                                          child: Visibility(

                                            visible: _productList[index].stock > 0 ? false : true,

                                            child: Container(

                                              alignment: Alignment.center,

                                              decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),

                                              child: Container(

                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),

                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                                                child: Text(

                                                  '${AppLocalizations.of(context).txt_out_of_stock}',

                                                  style: Theme.of(context).primaryTextTheme.headline2,

                                                ),

                                              ),

                                            ),

                                          ),

                                        ),

                                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),

                                        errorWidget: (context, url, error) => Container(

                                          child: Visibility(

                                            visible: _productList[index].stock > 0 ? false : true,

                                            child: Container(

                                              alignment: Alignment.center,

                                              decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),

                                              child: Container(

                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),

                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                                                child: Text(

                                                  '${AppLocalizations.of(context).txt_out_of_stock}',

                                                  style: Theme.of(context).primaryTextTheme.headline2,

                                                ),

                                              ),

                                            ),

                                          ),

                                          alignment: Alignment.center,

                                          decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(15),

                                            image: DecorationImage(

                                              image: AssetImage('${global.defaultImage}'),

                                              fit: BoxFit.cover,

                                            ),

                                          ),

                                        ),

                                      ),

                                      height: 140,

                                      width: 120,

                                    ),
                                    SizedBox(height: 4,),
                                    if(_productList[index].varient.length > 1)
                                    Text(_productList[index].varient.length.toString()+" Variants",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 11,color: Colors.green),)
                                  ],
                                ),

                              )

                            ],

                          ),

                        ),

                      );

                    },

                  ),

                  _isMoreDataLoaded

                      ? Center(

                    child: CircularProgressIndicator(

                      backgroundColor: Colors.white,

                      strokeWidth: 2,

                    ),

                  )

                      : SizedBox()

                ],

              ),

            )

                : Center(

              child: Text(

                "${AppLocalizations.of(context).txt_nothing_to_show}",

                style: Theme.of(context).primaryTextTheme.bodyText1,

              ),

            )

                : _productShimmer(),

          ),

        ),

      ),

    );

  }



  @override

  void dispose() {

    super.dispose();

  }



  @override

  void initState() {

    super.initState();

    _init();

  }



  _getData() async {

    try {

      if (screenId == 1 && subcategoryId != null) {

        await _getSubcategoryProduct();

      } else if (screenId == 2) {

        await _getTopSellingProduct();

      } else if (screenId == 3) {

        await _getSpotLightProduct();

      } else if (screenId == 4) {

        await _getRecentSellingProduct();

      } else if (screenId == 5) {

        await _getWhatsNewProduct();

      } else if (screenId == 6) {

        await _getDealProduct();

      } else if (screenId == 7) {

        _productFilter.keyword = title;

        // Search product

        await _getSearchedProduct();

      } else if (screenId == 8) {

        _productFilter.keyword = title;

        // tag product

        await _getTagProduct();

      }

      _productFilter.maxPriceValue = _productList.length > 0 ? _productList[0].maxPrice : 0;

    } catch (e) {

      print("Exception - productListScreen.dart - _init():" + e.toString());

    }

  }



  _getTopSellingProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.topSellingProduct(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getTopSellingProduct():" + e.toString());

    }

  }



  _getRecentSellingProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.recentSellingProduct(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getRecentSellingProduct():" + e.toString());

    }

  }



  _getWhatsNewProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.whatsnewProduct(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getWhatsNewProduct():" + e.toString());

    }

  }



  _getDealProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.dealProduct(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getDealProduct():" + e.toString());

    }

  }



  _getSearchedProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.getproductSearchResult(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getDealProduct():" + e.toString());

    }

  }


  _getCatSearchedProduct(String keywordd) async {

    try {

      print("aaaaaaaaa : "+keywordd);

      setState(() {

        _isMoreDataLoaded = true;

      });
        await apiHelper.getcatproductSearchResult(page, keywordd, subcategoryId.toString()).then((result) async {

          print("aaaaaaaaa : "+result.status);

          if (result != null) {

            if (result.status == "1") {
              _productList.clear();

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });


    } catch (e) {

      print("Exception - productListScreen.dart - _getDealProduct():" + e.toString());

    }

  }



  _getTagProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.getTagProduct(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getTagProduct():" + e.toString());

    }

  }



  _getSpotLightProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.spotLightProduct(page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);

              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getSpotLightProduct():" + e.toString());

    }

  }



  _getSubcategoryProduct() async {

    try {

      if (_isRecordPending) {

        setState(() {

          _isMoreDataLoaded = true;

        });

        if (_productList.isEmpty) {

          page = 1;

        } else {

          page++;

        }

        await apiHelper.getSubcategoryProduct(subcategoryId, mainCatId, page, _productFilter).then((result) async {

          if (result != null) {

            if (result.status == "1") {

              List<Product> _tList = result.data;

              if (_tList.isEmpty) {

                _isRecordPending = false;

              }

              _productList.addAll(_tList);



              setState(() {

                _isMoreDataLoaded = false;

              });

            }

          }

        });

      }

    } catch (e) {

      print("Exception - productListScreen.dart - _getSubcategoryProduct():" + e.toString());

    }

  }



  _init() async {

    try {

      await _getData();

      _scrollController.addListener(() async {

        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {

          setState(() {

            _isMoreDataLoaded = true;

          });

          await _getData();

          setState(() {

            _isMoreDataLoaded = false;

          });

        }

      });

      _isDataLoaded = true;

      setState(() {});

    } catch (e) {

      print("Exception - categoryListScreen.dart - _init():" + e.toString());

    }

  }



  Widget _productShimmer() {

    try {

      return ListView.builder(

        itemCount: 10,

        shrinkWrap: true,

        itemBuilder: (context, index) {

          return Container(

            margin: EdgeInsets.only(top: 10, bottom: 10),

            decoration: BoxDecoration(

              borderRadius: BorderRadius.all(

                Radius.circular(10),

              ),

            ),

            child: Shimmer.fromColors(

              baseColor: Colors.grey[300],

              highlightColor: Colors.grey[100],

              child: Column(

                children: [

                  SizedBox(

                    height: 110,

                    width: MediaQuery.of(context).size.width,

                    child: Card(),

                  ),

                ],

              ),

            ),

          );

        },

      );

    } catch (e) {

      print("Exception - wishlistScreen.dart - _productShimmer():" + e.toString());

      return SizedBox();

    }

  }

}

