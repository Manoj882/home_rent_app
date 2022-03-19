import 'package:flutter/cupertino.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/models/room_rent.dart';
import 'package:home_rent_app/provider/utilities_price_provider.dart';
import 'package:home_rent_app/utils/firebase_helper.dart';
import 'package:provider/provider.dart';

import '../utils/show_toast_message.dart';

class RoomRentProvider extends ChangeNotifier {
  final List<RoomRent> _roomRentList = [];

  List<RoomRent> get roomRentList => _roomRentList;

  fetchRoomRent({
    required String roomId,
  }) async {
    try {
      final data = await FirebaseHelper().getData(
        collectionId: RoomRentConstant.roomRentCollection,
        whereId: RoomRentConstant.roomId,
        whereValue: roomId,
      );
      // print(data.docs);
      if (_roomRentList.length != data.docs.length) {
        for (var element in data.docs) {
          _roomRentList.add(RoomRent.fromJson(element.data(), element.id));
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  addRoomRent(
    BuildContext context, {
    required String roomId,
    required String electricityUnitText,
    required String rentAmountText,
    required String month,
  }) async {
    try {
      final utilityProvider =
          Provider.of<UtilitiesPriceProvider>(context, listen: false);
      await utilityProvider.fetchPrice(context);

      final utilityPrice = utilityProvider.utilitiesPrice;
      if (utilityPrice == null) {
        showToast("Please enter utilities price for your home");
      } else {
        final electricityUnits = double.parse(electricityUnitText);
        final electricityPrice = electricityUnits*utilityPrice.electriciyUnitPrice;
        
        final rentAmount = double.parse(rentAmountText);
        final sum =
            electricityPrice + utilityPrice.internetFee + utilityPrice.waterFee;
        final map = RoomRent(
          roomId: roomId,
          month: month,
          electricityUnits: electricityUnits,
          electricityUnitPrice: utilityPrice.electriciyUnitPrice,
          electricityTotalPrice: electricityPrice,
          waterFee: utilityPrice.waterFee,
          internetFee: utilityPrice.internetFee,
          rentAmount: rentAmount,
          totalAmount: sum,
          paidAmount: 0,
          remainingAmount: sum,
        ).toJson();
        await FirebaseHelper().addData(
          context,
          map: map,
          collectionId: RoomRentConstant.roomRentCollection,
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  updateRoomRent(
    BuildContext context,
    {
    required String docId,
    required double paidAmount,
    required double remainingAmount,
  }) async {
    final map = {
      "paidAmount": paidAmount,
      "remainingAmount": remainingAmount - paidAmount,
    };
    await FirebaseHelper().updateData(
      context,
      map: map,
      collectionId: RoomRentConstant.roomRentCollection,
      docId: docId,
    );
    final room = _roomRentList.firstWhere((element) => element.roomRentId! == docId);
    room.paidAmount = paidAmount;
    room.remainingAmount = remainingAmount;
    final index = roomRentList.indexOf(room);
    _roomRentList.removeAt(index);
    notifyListeners();

  }
}
