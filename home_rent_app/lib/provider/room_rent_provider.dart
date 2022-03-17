import 'package:flutter/cupertino.dart';
import 'package:home_rent_app/constants/constants.dart';
import 'package:home_rent_app/models/room_rent.dart';
import 'package:home_rent_app/provider/utilities_price_provider.dart';
import 'package:home_rent_app/utils/firebase_helper.dart';
import 'package:provider/provider.dart';

import '../utils/show_toast_message.dart';

class RoomRentProvider extends ChangeNotifier {
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
        final electricityPrice = utilityPrice.electriciyUnitPrice;
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
          remainingAmount: 0,
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
}
