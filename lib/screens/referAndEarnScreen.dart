import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;

class ReferAndEarnScreen extends BaseRoute {
  ReferAndEarnScreen({a, o}) : super(a: a, o: o, r: 'ReferAndEarnScreen');
  @override
  _ReferAndEarnScreenState createState() => new _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState> _scaffoldKey;
  _ReferAndEarnScreenState() : super();
  String referMessage;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    print("width ${MediaQuery.of(context).size.width} - height ${MediaQuery.of(context).size.height}");
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return null;
      },
      child: SafeArea(
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
              title: Text("${AppLocalizations.of(context).tle_invite_earn}"),
            ),
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      Text(
                        // '${global.appInfo.refertext}',
                        'Refer & Earn',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.headline6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'First time in the World we have designed a unique cash back system where we share our profit on your purchase to referrer and referee equally.'+
                        'Therefore, you become our partners in profit only in our business Invite friends to shop with Ally Carto, once they shop with us not only they earn reward points you will also earn equal reward points.'+
                        ' One reward point is equal to Re1 where it can be used to shop with or AllyCart. Refer more people earn more. \n\n'+
                        'Share your below code and ask your friends and relatives to enter it while registering our app. Once they do it you become a partner in our business. ',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).primaryTextTheme.headline2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        child: InkWell(
                          customBorder: Theme.of(context).cardTheme.shape,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: "${global.currentUser.referralCode}"));
                          },
                          child: Container(
                            width: 180,
                            margin: EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${global.currentUser.referralCode}",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor),
                                ),
                                Text(
                                  '${AppLocalizations.of(context).txt_tap_to_copy}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).primaryTextTheme.button,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        br.inviteFriendShareMessage();
                      },
                      child: Text('${AppLocalizations.of(context).btn_invite_friends}')),
                ],
              ),
            )),
      ),
    );
  }

  _init() async {
    setState(() {});
  }
}
