import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:http/http.dart' as http;

class MyScannerr extends StatefulWidget {
  const MyScannerr({Key key}) : super(key: key);

  @override
  State<MyScannerr> createState() => _MyScannerState();
}

class _MyScannerState extends State<MyScannerr> {

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  TextEditingController _arxController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.resumeCamera();
    }
    controller.resumeCamera();
  }

  @override
  void initState() {

    super.initState();
  }


 void hideLoader() {
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed:  () {},
    );
    Widget continueButton = TextButton(
      child: Text("Continue", style: TextStyle(color: Colors.green)),
      onPressed:  () {
        Navigator.pop(context);
        sendData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm ARX Payment", style: TextStyle(color: Colors.red),),
      content: Text("Are you sure want to continue this ARX payment?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (result != null)
                  Text(result.code)
                else
                  const Text('Scan a code'),
                 Container(
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller?.resumeCamera();
                    },
                    child: const Text('Scan',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.pauseCamera();
                //         },
                //         child: const Text('pause',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.resumeCamera();
                //         },
                //         child: const Text('resume',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

Future<String> sendData2() async {
     try {
       showOnlyLoaderDialog();
       final data = {
         "user_id" : global.currentUser.id.toString(),
         "shop_id": shopId,
         "arx": _arxxController.text.toString(),
       };
       final headers = {
         'content-type': 'application/json',// 'key=YOUR_SERVER_KEY'
       };
       final response = await http.post(Uri.parse(global.baseUrl+"offlineorder_payment"),
           body: json.encode(data),
           headers: headers);

       var dataConvertedToJSON = json.decode(response.body);

       if(dataConvertedToJSON["status"].toString() == "1")
       {
         hideLoader();
         Navigator.pop(context);
       }
       return "Success";
     }  catch (e) {
       throw e;
     }
   }


}
