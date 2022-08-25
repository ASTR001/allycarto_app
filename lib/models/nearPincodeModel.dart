class NearPincodeModel {
  int id;
  String dist_id;
  String pincode;
  String pincode_name;
  NearPincodeModel();
  NearPincodeModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"].toString() != null ? int.parse(json["id"].toString()) : null;
      dist_id = json["distri_id"].toString() != null ? json["distri_id"].toString() : null;
      pincode = json["pincode"] != null ? json["pincode"] : null;
      pincode_name = json["name"] != null ? json["name"] : null;
    } catch (e) {
      print("Exception - nearPincodeModel.dart - NearPincodeModel.fromJson():" + e.toString());
    }
  }
}
