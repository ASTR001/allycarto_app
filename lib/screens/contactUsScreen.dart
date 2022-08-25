import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends BaseRoute {
  ContactUsScreen({a, o}) : super(a: a, o: o, r: 'ContactUsScreen');
  @override
  _ContactUsScreenState createState() => new _ContactUsScreenState();
}

class _ContactUsScreenState extends BaseRouteState {
  var _cFeedback = new TextEditingController();
  var _fFeedback = new FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _selectedStore;

  List<String> _storeName = ['Admin'];
  _ContactUsScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: global.isDarkModeEnable ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).inputDecorationTheme.fillColor,
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
          title: Text("${AppLocalizations.of(context).tle_contact_us}"),
        ),
        body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          '${global.defaultImage}',
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Address :",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "72, Karur Bypass Rd, Rajiv Nagar, Moolapalayam, Erode, Tamil Nadu 638002.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFe03337), Color(0xFFb73537),
                                  ],
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await launch(
                                        'tel:919791747474}');
                                  },
                                  icon: Icon(
                                    MdiIcons.phone,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFe03337), Color(0xFFb73537),
                                  ],
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await launch(
                                        'whatsapp://send?text=Hello&phone=${"919791747474"}');
                                  },
                                  icon: Icon(
                                    MdiIcons.whatsapp,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFe03337), Color(0xFFb73537),
                                  ],
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await launch(
                                        "mailto:ggfmho@gmail.com?subject=Hi");
                                  },
                                  icon: Icon(
                                    MdiIcons.email,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFe03337), Color(0xFFb73537),
                                  ],
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    AndroidIntent intent = AndroidIntent(
                                        action: 'action_view',
                                        data: Uri.encodeFull(
                                            'google.navigation:q=11.320606839943169,77.73245803645626&avoid=tf'),
                                        package: 'com.google.android.apps.maps');
                                    intent.launch();
                                  },
                                  icon: Icon(
                                    MdiIcons.map,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      )
                      // DropdownButtonFormField<String>(
                      //   decoration: InputDecoration(
                      //     fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                      //     contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      //   ),
                      //   dropdownColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                      //   icon: Padding(
                      //     padding: const EdgeInsets.only(right: 20),
                      //     child: Icon(
                      //       Icons.expand_more,
                      //       color: Theme.of(context).iconTheme.color,
                      //     ),
                      //   ),
                      //   style: Theme.of(context).primaryTextTheme.bodyText1,
                      //   value: _selectedStore,
                      //   items: _storeName
                      //       .map((label) => DropdownMenuItem(
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(left: 20),
                      //               child: Text(
                      //                 label.toString(),
                      //                 style: Theme.of(context).primaryTextTheme.bodyText1,
                      //               ),
                      //             ),
                      //             value: label,
                      //           ))
                      //       .toList(),
                      //   hint: Padding(
                      //     padding: const EdgeInsets.only(left: 20),
                      //     child: Text(
                      //       '${AppLocalizations.of(context).lbl_select_store}',
                      //       style: Theme.of(context).inputDecorationTheme.hintStyle,
                      //     ),
                      //   ),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedStore = value;
                      //     });
                      //   },
                      // ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 8.0),
                      //     child: Text(
                      //       "${AppLocalizations.of(context).lbl_callback_desc}",
                      //       textAlign: TextAlign.center,
                      //       style: Theme.of(context).primaryTextTheme.bodyText1,
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       gradient: LinearGradient(
                      //         stops: [0, .90],
                      //         begin: Alignment.centerLeft,
                      //         end: Alignment.centerRight,
                      //         colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                      //       ),
                      //     ),
                      //     margin: EdgeInsets.all(4.0),
                      //     padding: EdgeInsets.all(4.0),
                      //     height: 50,
                      //     alignment: Alignment.center,
                      //     child: TextButton(
                      //         style: TextButton.styleFrom(
                      //             padding: EdgeInsets.zero,
                      //             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //             alignment: Alignment.centerLeft),
                      //         onPressed: () async {
                      //           await _sendCallbackRequest();
                      //         },
                      //         child: Text('${AppLocalizations.of(context).btn_callback_request}')),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     "${AppLocalizations.of(context).lbl_contact_desc}",
                      //     style: Theme.of(context).primaryTextTheme.bodyText1,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   "${AppLocalizations.of(context).lbl_your_feedback}",
                      //   style: Theme.of(context).primaryTextTheme.headline2,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                      //   margin: EdgeInsets.only(top: 5, bottom: 15),
                      //   padding: EdgeInsets.only(),
                      //   child: TextFormField(
                      //     textCapitalization: TextCapitalization.sentences,
                      //     controller: _cFeedback,
                      //     focusNode: _fFeedback,
                      //     maxLines: 3,
                      //     style: Theme.of(context).primaryTextTheme.bodyText1,
                      //     decoration: InputDecoration(
                      //       fillColor: global.isDarkModeEnable ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).scaffoldBackgroundColor,
                      //       hintText: '${AppLocalizations.of(context).hnt_enter_msg}',
                      //       contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
        // bottomNavigationBar: global.nearStoreModel.id != null
        //     ? Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Expanded(
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(10)),
        //                 gradient: LinearGradient(
        //                   stops: [0, .90],
        //                   begin: Alignment.centerLeft,
        //                   end: Alignment.centerRight,
        //                   colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
        //                 ),
        //               ),
        //               margin: EdgeInsets.all(8.0),
        //               height: 50,
        //               width: MediaQuery.of(context).size.width,
        //               child: TextButton(
        //                   onPressed: () async {
        //                     await _submitFeedBack();
        //                   },
        //                   child: Text('${AppLocalizations.of(context).btn_submit}')),
        //             ),
        //           ),
        //         ],
        //       )
        //     : null,
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
    // if (global.nearStoreModel.id != null) {
    //
    //   _storeName.insert(0, global.nearStoreModel.storeName);
    // }
  }

  _sendCallbackRequest() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.calbackRequest(_selectedStore == 'Admin' ? null : _selectedStore).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              showSnackBar(snackBarMessage: 'Callback request sent successfully.', key: _scaffoldKey);
            } else {
              hideLoader();
              showSnackBar(snackBarMessage: 'Something went wrong, please try again later.', key: _scaffoldKey);
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - contactUsSceen.dart - _submitFeedBack():" + e.toString());
    }
  }

  _submitFeedBack() async {
    try {
      if (_cFeedback.text.trim().isNotEmpty) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper.sendUserFeedback(_cFeedback.text.trim()).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                hideLoader();
                showSnackBar(snackBarMessage: 'Feedback sent successfully.', key: _scaffoldKey);
              } else {
                hideLoader();
                showSnackBar(snackBarMessage: 'Something went wrong, please try again later.', key: _scaffoldKey);
              }
            }
          });
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else {
        showSnackBar(snackBarMessage: 'Please enter your valuable feedback.', key: _scaffoldKey);
      }
    } catch (e) {
      print("Exception - contactUsSceen.dart - _submitFeedBack():" + e.toString());
    }
  }
}
