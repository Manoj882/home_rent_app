class UtilitiesPrice{
  late double waterFee;
  late double electriciyUnitPrice;
  late double internetFee;
  late String uuid;

  UtilitiesPrice({
    required this.waterFee,
    required this.electriciyUnitPrice,
    required this.internetFee,
    required this.uuid,
  });

  UtilitiesPrice.fromJson(Map obj){
    waterFee = obj["water"];
    electriciyUnitPrice = obj["electricity"];
    internetFee = obj["internet"];
    uuid = obj["uuid"];
  }

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map["water"] = waterFee;
    map["electricity"] = electriciyUnitPrice;
    map["internet"] = internetFee;
    map["uuid"] = uuid;
    return map;
  }

}