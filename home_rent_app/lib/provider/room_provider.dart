import 'package:flutter/cupertino.dart';
import 'package:home_rent_app/models/room.dart';
import 'package:home_rent_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../utils/firebase_helper.dart';

class RoomProvider extends ChangeNotifier {
  final List<Room> _listOfRoom = [];

  List<Room> get listOfRoom => _listOfRoom;

  fetchRoom(BuildContext context) async {
    try {
      final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;
      final data = await FirebaseHelper().getData(
       
        collectionId: RoomConstant.roomCollection,
        whereId: UserConstants.userId,
        whereValue: uuid,
      );
      if(data.docs.length != _listOfRoom.length){
        _listOfRoom.clear();
        
         for(var element in data.docs) {
        // print(element.data());
        
         _listOfRoom.add(Room.fromJson(element.data(),element.id));
       }

      }
     
      
    } catch (ex) {
      print(ex.toString());
      throw ex.toString();
    }
  }

  addRoom(BuildContext context, String name) async {
    try {
      final uuid = Provider.of<UserProvider>(context, listen: false).user.uuid;
      final map = Room(
        name: name,
        uuid: uuid,
      ).toJson();
      
      await FirebaseHelper().addData(
        context,
        map: map,
        collectionId: RoomConstant.roomCollection,
      );
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      print(ex.toString());
      throw ex.toString();
    }
  }
}
