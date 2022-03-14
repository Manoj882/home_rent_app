class Room{
  late String name;
  late String uuid;

  Room({
    required this.name,
    required this.uuid,
  });

  Room.fromJson(Map obj){
    name = obj["name"];
    uuid = obj["uuid"];
  }
  Map<String, dynamic> toJson(){
    final map = <String, dynamic> {};
    map["name"] = name;
    map["uuid"] = uuid;
    return map;

  }
}