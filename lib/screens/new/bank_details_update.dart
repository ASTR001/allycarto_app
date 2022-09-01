import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gomeat/models/addressModel.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/models/societyModel.dart';
import 'package:shimmer/shimmer.dart';

class AddBankDetails extends BaseRoute {
  final String address;
  final String bankk;
  final String accc;
  final String ifscc;
  final String namee;
  AddBankDetails(this.address,  this.bankk, this.accc, this.ifscc, this.namee, {a, o}) : super(a: a, o: o, r: 'AddAddressScreen');
  @override
  _AddAddressScreenState createState() => new _AddAddressScreenState(this.address, this.bankk, this.accc, this.ifscc, this.namee);
}

class _AddAddressScreenState extends BaseRouteState {
  var _cName = new TextEditingController();
  var _cBank= new TextEditingController();
  var _cAcc = new TextEditingController();
  var _cIfsc = new TextEditingController();

  var _fName = new FocusNode();
  var _fBank = new FocusNode();
  var _fAcc = new FocusNode();
  var _fIfsc = new FocusNode();

  GlobalKey<ScaffoldState> _scaffoldKey;
  var address, bankk, accc, ifscc, namee;
  _AddAddressScreenState(this.address, this.bankk, this.accc, this.ifscc, this.namee) : super();

  @override
  void initState() {
    super.initState();
    if(address == "0") {
      _cName.text = namee;
      _cBank.text = bankk;
      _cAcc.text = accc;
      _cIfsc.text = ifscc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: global.isDarkModeEnable ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).inputDecorationTheme.fillColor,
        appBar: AppBar(
          leadingWidth: 0,
          leading: SizedBox(),
          title: address == "1" ? Text("Add Bank Details") : Text('Edit Bank Details'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: Icon(
                FontAwesomeIcons.windowClose,
                color: Theme.of(context).appBarTheme.actionsIconTheme.color,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                padding: EdgeInsets.only(),
                child: TextFormField(
                  controller: _cBank,
                  focusNode: _fBank,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                    hintText: 'Bank Name',
                    contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_fAcc);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                padding: EdgeInsets.only(),
                child: TextFormField(
                  controller: _cAcc,
                  focusNode: _fAcc,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    counterText: '',
                    fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                    hintText: 'Account Number',
                    contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_fIfsc);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                padding: EdgeInsets.only(),
                child: TextFormField(
                  controller: _cIfsc,
                  focusNode: _fIfsc,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                    hintText: 'IFSC',
                    contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_fName);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                padding: EdgeInsets.only(),
                child: TextFormField(
                  controller: _cName,
                  focusNode: _fName,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                    hintText: 'Account Holder Name',
                    contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                  // onFieldSubmitted: (val) {
                  //   FocusScope.of(context).requestFocus(_fPincode);
                  // },
                ),
              ),

            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    stops: [0, .90],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFe03337), Color(0xFFb73537)],
                  ),
                ),
                margin: EdgeInsets.all(8.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      _save();
                    },
                    child: Text('Save Bank Details')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


  _save() async {
    try {
      if (_cName != null &&
          _cName.text.isNotEmpty &&
          _cAcc.text != null &&
          _cAcc.text.isNotEmpty &&
          _cBank != null &&
          _cBank.text.isNotEmpty &&
          _cIfsc.text != null &&
          _cIfsc.text.isNotEmpty) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();

          if (address == "0") {
            await apiHelper.addBank(_cName.text.toString(),_cBank.text.toString(),_cAcc.text.toString(),_cIfsc.text.toString(),).then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  hideLoader();
                  Navigator.of(context).pop(true);
                } else {
                  hideLoader();
                  showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
                }
              }
            });
          } else {
            await apiHelper.addBank(_cName.text.toString(),_cBank.text.toString(),_cAcc.text.toString(),_cIfsc.text.toString(),).then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  hideLoader();
                  Navigator.of(context).pop(true);
                }
              }
            });
          }
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else if (_cName.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context).txt_please_enter_your_name);
      } else if (_cBank.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: "Please enter bank name");
      } else if (_cAcc.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enter account number');
      } else if (_cIfsc.text.trim().isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enter ifsc');
      }
    } catch (e) {
      print("Excetion - addAddessScreen.dart - _save():" + e.toString());
    }
  }
}
