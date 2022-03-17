class RoomRent{
  late String month;
  late String roomId;
  late double electricityUnits;
  late double electricityUnitPrice;
  late double electricityTotalPrice;
  late double waterFee;
  late double internetFee;
  late double rentAmount;
  late double totalAmount;
  late double paidAmount;
  late double remainingAmount;

  RoomRent({
    required this.month,
    required this.roomId,
    required this.electricityUnits,
    required this.electricityUnitPrice,
    required this.electricityTotalPrice,
    required this.waterFee,
    required this.internetFee,
    required this.rentAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,


  });

  RoomRent.fromJson(Map obj){
    month = obj["month"];
    roomId = obj["roomId"];
    electricityUnits = obj["electricityUnits"];
    electricityUnitPrice = obj["electricityUnitPrice"];
    electricityTotalPrice = obj["electricityTotalPrice"];
    waterFee = obj["waterFee"];
    internetFee = obj["internetFee"];
    rentAmount = obj["rentAmount"];
    totalAmount = obj["totalAmount"];
    paidAmount = obj["paidAmount"];
    remainingAmount = obj["remainingAmount"];
  }

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map["month"] = month;
    map["roomId"] = roomId;
    map["electricityUnits"] = electricityUnits;
    map["electricityUnitPrice"] = electricityUnitPrice;
    map["electricityTotalPrice"] = electricityTotalPrice;
    map["waterFee"] = waterFee;
    map["internetFee"] = internetFee;
    map["rentAmount"] = rentAmount;
    map["totalAmount"] = totalAmount;
    map["paidAmount"] = paidAmount;
    map["remainingAmount"] = remainingAmount;

    return map;
  }

}