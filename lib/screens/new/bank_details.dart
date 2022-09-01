import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/addressModel.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/screens/addAddressScreen.dart';
import 'package:gomeat/screens/new/bank_details_update.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class BankListScreen extends BaseRoute {
  BankListScreen({a, o}) : super(a: a, o: o, r: 'BankListScreen');
  @override
  _bankListScreenState createState() => new _bankListScreenState();
}

class _bankListScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

   var _bankList;
  GlobalKey<ScaffoldState> _scaffoldKey;

  _bankListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
          centerTitle: true,
          title: Text("Manage Bank Details"),

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isDataLoaded
              ? RefreshIndicator(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              color: Theme.of(context).primaryColor,
              onRefresh: () async {
                _isDataLoaded = false;
                setState(() {});
                await _init();
              },
              child:  Column(
                children: [
                  Visibility(
                    visible: _bankList != null ? false : true,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => AddBankDetails("1","","","","", a: widget.analytics, o: widget.observer),
                          ),
                        )
                            .then((value) async {
                          if (value != null) {
                            showOnlyLoaderDialog();
                            await _init();
                            hideLoader();
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        padding: EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFe03337), Color(0xFFb73537)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: global.isDarkModeEnable ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "Add Bank Details",
                              style: TextStyle(fontSize: 16, color: global.isDarkModeEnable ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor, fontWeight: FontWeight.w400),
                            )),
                      ),
                    ),
                  ),
                  _bankList != null
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          _bankList["account_holder"] ?? "",
                          style: TextStyle(fontSize: 17,color: Colors.black87),
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bankList["bank_name"],
                              style: TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              _bankList["bank_account"],
                              style: TextStyle(fontSize: 15,color: Colors.black87),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              _bankList["bank_ifsc"],
                              style: TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            SizedBox(height: 2,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => AddBankDetails("0",_bankList["bank_name"],_bankList["bank_account"],_bankList["bank_ifsc"],_bankList["account_holder"], a: widget.analytics, o: widget.observer),
                                        ),
                                      )
                                          .then((value) async {
                                        if (value != null && value) {
                                          _isDataLoaded = false;
                                          setState(() {});
                                          await _init();
                                        }
                                      });
                                    },
                                    icon: Image.asset('assets/edit.png')),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ) : Center(
                    child: Text(
                      "${AppLocalizations.of(context).txt_nothing_to_show}",
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                  ),
                ],
              )
          )
              : _shimmerList(),
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

  _init() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getBankList().then((result) async {
          if (result != null) {
            print("aaaaaaaaaaaaa : "+result.data.toString());
            print("aaaaaaaaaaaaa : "+result.status.toString());
            if (result.status.toString() == "200") {
              _bankList = result.data;
              print("aaaaaaaaaaaaa : "+_bankList.toString());
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - addressListScreen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 112,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - addAddressScreen.dart - _shimmerList():" + e.toString());
      return SizedBox();
    }
  }
}
