import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gomeat/models/businessLayer/global.dart' as global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _cmdController = TextEditingController();
  String dropdownvalue = 'Select Your Issue';

  File _imageFile1;
  File _imageFile2;
  final picker = ImagePicker();
  String Imgg1= "";
  String Imgg2 = "";
  String myType = "";

  String _image1;
  String _image2;

  // List of items in our dropdown menu
  var items = [
    'Select Your Issue',
    'Login Issues',
    'Order Related Issues',
    'Shipping Issues',
    'Product Issues',
    'Incentive Issues',
    'Payment Issues',
    'Others',
  ];

  // var items = [
  //   {"name" : "Login Issues", "sts" : "1"},
  //   {"name" : "Order Related Issues", "sts" : "0"},
  //   {"name" : "Shipping Issues", "sts" : "0"},
  //   {"name" : "Product Issues", "sts" : "0"},
  //   {"name" : "Incentive Issues", "sts" : "1"},
  //   {"name" : "Payment Issues", "sts" : "1"},
  //   {"name" : "Others", "sts" : "1"},
  // ];

  void _onAlertPress( BuildContext context, String positionType) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    // Image.asset(
                    //   'assets/IMGG.png',
                    //   width: 50,
                    // ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: () async {
                  if (positionType == 'image1') {
                    _imageFile1 = await getGalleryImage("1");
                  } else if (positionType == 'image2') {
                    _imageFile2 = await getGalleryImage("2");
                  }
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    // Image.asset(
                    //   'assets/camicon.png',
                    //   width: 50,
                    // ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: () async {
                  if (positionType == 'image1') {
                    _imageFile1 = await getTakeImage("1");
                  } else if (positionType == 'image2') {
                    _imageFile2 = await getTakeImage("2");
                  }
                },
              ),
            ],
          );
        });
  }


  getGalleryImage(String imgPos) async {
    File _image;
    final pickedFile = await picker.getImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 100,
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
    if (_image != null) {
      final bytes = File(pickedFile.path).readAsBytesSync();

      if(imgPos == "1") {
        Imgg1 = base64Encode(bytes);
      } else if(imgPos == "2") {
        Imgg2 = base64Encode(bytes);
      }
      // compressImage(_image, imgPos);
    }
    return _image;
  }

  getTakeImage(String imgPos) async {
    File _image;
    final pickedFile = await picker.getImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 80,
        source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        final bytes = File(pickedFile.path).readAsBytesSync();
        Navigator.pop(context);
        if(imgPos == "1") {
          Imgg1 = base64Encode(bytes);
        } else if(imgPos == "2") {
          Imgg2 = base64Encode(bytes);
        }

      } else {
        print('No image selected.');
      }
    });

    if (_image != null) {
      // compressImage(_image, imgPos);
    }
    return _image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Tickets"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.grey[50],
                child: DropdownButton(
                  dropdownColor: Colors.grey[50],
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(items),
                      ),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      if(newValue == "Order Related Issues" || newValue == "Shipping Issues" || newValue == "Product Issues") {
                        myType = "0";
                      } else {
                        myType = "1";
                      }
                      dropdownvalue = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 12,),
              Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _cmdController,
                      maxLines: 4, //or null
                      decoration: InputDecoration.collapsed(hintText: "Enter your text here", hintStyle: TextStyle(color: Colors.black87)),
                    ),
                  )
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Image-1 * :",style: TextStyle(fontSize: 14,color: Colors.black87)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0,right: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        _onAlertPress(context,'image1');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width / 4.7,
                        width: MediaQuery.of(context).size.width / 4.7,
                        color: Colors.grey[200],
                        child: _imageFile1 != null
                            ? Image.file(_imageFile1)
                            : Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              "assets/camicon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Image-2 (Optional) :",style: TextStyle(fontSize: 14,color: Colors.black87)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0,right: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        _onAlertPress(context,'image2');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width / 4.7,
                        width: MediaQuery.of(context).size.width / 4.7,
                        color: Colors.grey[200],
                        child: _imageFile2 != null
                            ? Image.file(_imageFile2)
                            : Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              "assets/camicon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                child: FlatButton(
                  child: Text('SUBMIT'),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    submitCheck();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submitCheck() {
    if (dropdownvalue == "Select Your Issue") {
      showSnackBar(key: _scaffoldKey, snackBarMessage: "  Please selecet issue type!  ");
    } else if (_cmdController.text == "") {
      showSnackBar(key: _scaffoldKey, snackBarMessage: "  Please enter comment!  ");
    } else if (_imageFile1 == null) {
      showSnackBar(key: _scaffoldKey, snackBarMessage: "  Please choose image!  ");
    } else {
      submitData();
    }
  }

  Future submitData() async {
    showOnlyLoaderDialog();
    var myPincode = global.sp.getString('myPincode');
    Uri uri = Uri.parse('${global.baseUrl}ticket');

    var map = new Map<String, dynamic>();
    map['user_id'] = global.currentUser.id.toString();
    map['pincode'] = myPincode;
    map['issue'] = dropdownvalue;
    map['type'] = myType;
    map['comment'] = _cmdController.text.toString();
    map['image1'] = Imgg1.toString();
    map['image2'] = Imgg2.toString();

    http.Response response = await http.post(uri,
        body: map);

    print("aaaaaaaaaabbbbbbbbbbbbb : "+response.body.toString());

    var jsonData = jsonDecode(response.body);

    String status = jsonData['status'].toString();

    if (status == "200") {
      hideLoader();
      showSnackBar(key: _scaffoldKey, snackBarMessage: "  Ticket submitted successfully!  ");
      Navigator.pop(context);
    } else {
      hideLoader();
    }
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  void showSnackBar({String snackBarMessage, Key key}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryTextTheme.headline5.color,
      key: key,
      content: Text(
        snackBarMessage,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
  }

}
