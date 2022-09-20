import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomeat/models/aboutUsModel.dart';
import 'package:gomeat/models/businessLayer/baseRoute.dart';
import 'package:gomeat/models/termsOfServiceModel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class AboutUsAndTermsOfServiceScreen extends BaseRoute {
  final bool isAboutUs;
  AboutUsAndTermsOfServiceScreen(this.isAboutUs, {a, o}) : super(a: a, o: o, r: 'AboutUsAndTermsOfServiceScreen');
  @override
  _AboutUsAndTermsOfServiceScreenState createState() => new _AboutUsAndTermsOfServiceScreenState(this.isAboutUs);
}

class _AboutUsAndTermsOfServiceScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  final bool isAboutUs;
  String text = "";
  AboutUs _aboutUs = new AboutUs();
  TermsOfService _termsOfService = new TermsOfService();
  _AboutUsAndTermsOfServiceScreenState(this.isAboutUs) : super();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: new Container(
          constraints: new BoxConstraints.expand(),
          color: Colors.white,
          child: new Stack (
            children: <Widget>[
              _getBackground(),
              // _getGradient(),
              // _getContent(),
              _getToolbar(context),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _getBackground () {
    return SingleChildScrollView(
      child: Column(
        children: [
          new Container(
            child: new Image.asset('assets/logo.jpg',
              fit: BoxFit.cover,
              height: 200.0,
              width: 200.0,
            ),
            constraints: new BoxConstraints.expand(height: 200.0,width: 200.0,),
          ),
          SizedBox(height: 15,),
          isAboutUs ? Text("About App",style: TextStyle(fontSize: 18,color: Colors.red),) : Text("Customer Policy",style: TextStyle(fontSize: 18,color: Colors.red),),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Html(
              data: "$text",
              style: {
                "body": Style(color: Theme.of(context).primaryTextTheme.bodyText1.color),
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            new Color(0x00736AB7),
            new Color(0xFF736AB7)
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(
          top: 10),
      child: new BackButton(color: Colors.black),
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
        if (isAboutUs) {
          await apiHelper.appAboutUs().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _aboutUs = result.data;
                text = _aboutUs.description;
              }
            }
          });
        } else {
          await apiHelper.appTermsOfService().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _termsOfService = result.data;
                text = _termsOfService.description;
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - aboutUsAndTermsOfServiceScreen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            height: MediaQuery.of(context).size.height - 120,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 120,
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
      print("Exception - aboutUsAndTermsOfServiceScreen.dart - _shimmerList():" + e.toString());
      return SizedBox();
    }
  }
}
