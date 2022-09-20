import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:gomeat/screens/otpVerificationScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NeedHelpScreen extends BaseRoute {
  NeedHelpScreen({a, o}) : super(a: a, o: o, r: 'ForgotPasswordScreen');
  @override
  _ForgotPasswordScreenState createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _cPhone = new TextEditingController();
  var _fPhone = new FocusNode();
  var _dismiss = new FocusNode();
  _ForgotPasswordScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return null;
        },
        child: Scaffold(
            key: _scaffoldKey,
            body: Container(
              decoration: global.isDarkModeEnable
                  ? BoxDecoration(
                gradient: LinearGradient(
                  stops: [0, 0.65],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF50546F), Color(0xFF8085A3)],
                ),
              )
                  : BoxDecoration(
                gradient: LinearGradient(
                  stops: [0, 0.65],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/login_signup.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: global.isRTL ? null : 10,
                    right: global.isRTL ? 10 : null,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(MdiIcons.arrowLeft, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: 22, // MediaQuery.of(context).size.height * 0.07,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Need Help',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 35),
                    decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(40))),
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45 - 20),
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Please provide valid mobile number.', style: Theme.of(context).primaryTextTheme.bodyText1),
                          Padding(
                            padding: EdgeInsets.only(top: 2, bottom: 20),
                            child: Text('Our team contact soon.', style: Theme.of(context).primaryTextTheme.bodyText1),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            padding: EdgeInsets.only(),
                            child: TextFormField(
                              controller: _cPhone,
                              focusNode: _fPhone,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.phone,
                              maxLength: global.appInfo.phoneNumberLength,
                              style: Theme.of(context).primaryTextTheme.bodyText1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_dismiss);
                              },
                              decoration: InputDecoration(
                                hintText: '${AppLocalizations.of(context).lbl_phone_number}',
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Theme.of(context).inputDecorationTheme.hintStyle.color,
                                ),
                                prefixText: '+${global.appInfo.countryCode} ',
                                prefixStyle: Theme.of(context).primaryTextTheme.bodyText1,
                                counterText: '',
                                contentPadding: EdgeInsets.only(top: 10),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), gradient: LinearGradient(stops: [0, .90], begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor])),
                            margin: EdgeInsets.only(top: 20),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                                onPressed: () async {
                                  await _sendOTP();
                                },
                                child: Text('Submit')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                                    thickness: 2,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('  ${AppLocalizations.of(context).btn_back_to_login}   ', style: Theme.of(context).primaryTextTheme.headline1)),
                                Expanded(
                                    child: Divider(
                                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                                      thickness: 2,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
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
  }

  _sendOTP() async {
    try {
      if (_cPhone.text.isNotEmpty && _cPhone.text.trim().length == global.appInfo.phoneNumberLength) {
        showOnlyLoaderDialog();
        await apiHelper.need_help(_cPhone.text).then((result) async {

          if (result != null) {
            if (result.status.toString() == "1") {
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              hideLoader();

              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
            }
          }
        });
      } else {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context).txt_please_enter_valid_mobile_number}');
      }
    } catch (e) {
      print("Exception - forgotPasswordScreen.dart - _sendOTP():" + e.toString());
    }
  }
}
